run_analysis <- function(){

require(reshape2)
require(dplyr)

# -----------------------------------------------------------------------------
# 1) Merge the training and the test sets to create one tidy data set
# -----------------------------------------------------------------------------
# Load the activity and feature labels
tDataDir <- "./UCI HAR Dataset/"
tLoadFilename <- paste(tDataDir,"activity_labels.txt",sep = "")
dActivityLabels <- read.csv(file = tLoadFilename,header=F,sep="")
tLoadFilename <- paste(tDataDir,"features.txt",sep = "")
dFeatureLabels <- read.csv(file = tLoadFilename,header=F,sep="")

# Load the feature data
lPostfixes <- list("train","test")
sObsStartIx <- 1
dFeatData <- data.frame() # frame which will contain all feature data
for(tPostfix in lPostfixes){
    tFilename <- paste(tDataDir,tPostfix,"/X_",tPostfix,".txt",sep = "")
    dReadIn <- read.csv(file = tFilename,header=F,sep="")
    sNumObs <- nrow(dReadIn)
    sObsEndIx <- sObsStartIx + sNumObs - 1
    sNumVars <- ncol(dReadIn)
    
    # Read the subject/activity ID per observation
    tFilename <- paste(tDataDir,tPostfix,"/subject_",tPostfix,".txt",sep="")
    dSubjectId <- read.csv(file = tFilename,header=F,sep="")
    tFilename <- paste(tDataDir,tPostfix,"/y_",tPostfix,".txt",sep="")
    dActivityId <- read.csv(file = tFilename,header=F,sep="")
    
    # Read feature-data and add identifying columns (including descriptive 
    # activity names to name the activities in the data set)
    dReadOut <- dReadIn %>% 
        mutate(obsIx = seq(sObsStartIx,sObsEndIx)) %>%
        mutate(subjectId=dSubjectId[1:sNumObs,1]) %>% 
        mutate(activity=dActivityLabels[dActivityId[1:sNumObs,1],2]) %>% 
        mutate(classType=factor(x=tPostfix,levels=lPostfixes)) %>%
        select((sNumVars+1):(sNumVars+4),(1:sNumVars))
    
    # Combine test/training data
    if(nrow(dFeatData)>0){dFeatData <- rbind(dFeatData,dReadOut)}
    else{dFeatData <- dReadOut}
    sObsStartIx <- sObsStartIx + sNumObs
}

# Label the data set with descriptive variable names
for(iCol in seq(5,ncol(dFeatData))){
    colnames(dFeatData)[iCol] <- paste(dFeatureLabels[dFeatureLabels[,1] == 
                                    (iCol-4),2])
}

# -----------------------------------------------------------------------------
# Extract the measurements on the mean and standard deviation for each measurement
# -----------------------------------------------------------------------------
dFeatDataSel <- dFeatData[,c(seq(1,4),grep(pattern = "mean\\(\\)|std\\(\\)", 
                        colnames(dFeatData)))]

# -----------------------------------------------------------------------------
# Create an independent tidy data set with the average of each variable for 
# each activity and each subject
# -----------------------------------------------------------------------------
# Generate a grouping ID according to the combination of subject+activity
dFeatDataSel_bySubjAct <- dFeatDataSel %>% 
    mutate(groupId = interaction(subjectId,activity)) %>% 
    group_by(groupId)
# Generate a table with per-variable means for each group ID
dSummaryId <- summarise(dFeatDataSel_bySubjAct,subjectId=unique(subjectId),
                        activity=unique(activity),classType=unique(classType))
dSummary <- merge(dSummaryId,summarise_each(dFeatDataSel_bySubjAct,funs(mean),
                (5:(ncol(dFeatDataSel_bySubjAct)-1)))) %>% 
            select(-groupId) %>% arrange(subjectId)
# Correct the variable names accordingly
colnames(dSummary)[-(1:3)] <- paste("mean-",colnames(dSummary)[-(1:3)],sep="")
#
dSummary
}