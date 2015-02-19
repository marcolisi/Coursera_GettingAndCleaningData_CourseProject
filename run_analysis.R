library(sqldf)

getTheAveragesOfTheTrainingAndTestDataByActivityAndSubject <-
    function()
    {
        theTrainingAndTestData <-
            getTheTrainingAndTestData()
        
        theNamesOfTheMeansAndStandardDeviationColumns <-
            names(theTrainingAndTestData)[c(-1, -2, -3)]
        
        theAverageMeansAndStandardDeviationsSqlStatement <-
            paste(
                'avg("',
                theNamesOfTheMeansAndStandardDeviationColumns,
                '") `AVG-',
                theNamesOfTheMeansAndStandardDeviationColumns,
                '`',
                
                sep = "",
                
                collapse = ", "
            )
        
        theSqlStatementToAverageBySubjectAndActivity <-
            paste(
                "select ActivityId, ActivityName, SubjectId, ",
                theAverageMeansAndStandardDeviationsSqlStatement,
                "from theTrainingAndTestData",
                "group by ActivityId, ActivityName, SubjectId"
            )
        
        theAveragesBySubjectAndActivity <-
            sqldf(
                theSqlStatementToAverageBySubjectAndActivity
            )
            
        
        theAveragesBySubjectAndActivity
    }

getTheTrainingAndTestData <-
    function()
    {
        theTrainingData <-
            getTheMeansAndStandardDeviationsOfTheSpecifiedData("train")
        
        theTestData <-
            getTheMeansAndStandardDeviationsOfTheSpecifiedData("test")
        
        theMergedTrainingAndTestData <-
            rbind(
                theTrainingData,
                theTestData
            )
        
        theMergedTrainingAndTestData
    }

basePathOfTheData <-
    "UCI HAR Dataset/"


getTheMeansAndStandardDeviationsOfTheSpecifiedData <-
    function(
        theNameOfTheData # either test or train
    )
    {
        theSubjectIds <-
            getTheSubjectsOfTheSpecifiedData(
                theNameOfTheData
            )
        
        theActivities <-
            getTheActivitiesOfTheSpecifiedData(
                theNameOfTheData
            )
        
        theData <-
            getTheSpecifiedData(
                theNameOfTheData
            )
        
        # add the activity id and name columns
        theData <-
            cbind(
                theActivities,
                theData
            )
        
        # add the subject id column
        theData <-
            cbind(
                theSubjectIds,
                theData
            )
        
        theIndexesOfTheFeaturesRegardingMeansAndStandardDeviations <-
            getTheIndexesOfTheFeaturesRegardingMeansAndStandardDeviations()
        
        # take only the 
        theData <-
            theData[
                ,
                c(
                    1, # subject id
                    2, # activity id
                    3, # activity name
                    (theIndexesOfTheFeaturesRegardingMeansAndStandardDeviations + 3)
                )
            ]
        
        theData
    }

getTheSubjectsOfTheSpecifiedData <-
    function(
        theNameOfTheData # either test or train
    )
    {
        theSubjectIds <-
            read.table(
                paste(
                    basePathOfTheData,
                    theNameOfTheData,
                    "/subject_",
                    theNameOfTheData,
                    ".txt",
                    
                    sep = ""
                ),
                
                header = FALSE,
                
                col.names = c("SubjectId")
            )
        
        theSubjectIds
}

getTheActivitiesOfTheSpecifiedData <-
    function(
        theNameOfTheData # either test or train
    )
    {
        theActivityIds <-
            getTheActivityIdsOfTheSpecifiedData(
                theNameOfTheData
            )
        
        theActivityMasterData <-
            getTheActivityMasterData()
        
        theActivities <-
            merge(
                theActivityIds,
                theActivityMasterData,
                by.x = "ActivityId",
                by.y = "Id")
        
        names(theActivities)[2] <-
            "ActivityName"
        
        theActivities
    }

getTheActivityIdsOfTheSpecifiedData <-
    function(
        theNameOfTheData # either test or train
    )
    {
        theActivityIds <-
            read.table(
                paste(
                    basePathOfTheData,
                    theNameOfTheData,
                    "/y_", 
                    theNameOfTheData,
                    ".txt",
                    
                    sep = ""
                ),
                
                header = FALSE,
                
                col.names = c("ActivityId")
            )
        
        theActivityIds
    }

getTheSpecifiedData <-
    function(
        theNameOfTheData # either test or train
    )
    {
        theFeatureIndexesAndNames <-
            getTheFeatureIndexesAndNames()
        
        theData <-
            read.table(
                paste(
                    basePathOfTheData,
                    theNameOfTheData,
                    "/X_", 
                    theNameOfTheData,
                    ".txt",
                    
                    sep = ""
                ),
                
                header = FALSE,
                
                col.names = theFeatureIndexesAndNames$Name
            )
        
        theData
    }

getTheIndexesOfTheFeaturesRegardingMeansAndStandardDeviations <-
    function()
    {
        theFeatures <-
            getTheFeatureIndexesAndNames()
        
        theFeaturesRegardingMeansAndStandardDeviations <-
            theFeatures[
                grep(
                    "mean|std", 
                    theFeatures$Name, 
                    ignore.case = TRUE
                ),
            ]
        
        theFeaturesRegardingMeansAndStandardDeviations$Index
    }

getTheFeatureIndexesAndNames <-
    function()
    {
        theFeatureIndexesAndNames <-
            read.table(
                paste(
                    basePathOfTheData,
                    "features.txt",
                    
                    sep = ""
                ),
                
                header = FALSE,
                
                col.names =
                    c(
                        "Index",
                        "Name"
                    )
            )
        
        theFeatureIndexesAndNames$Name <-
            gsub(
                "\\(\\)",
                "",
                theFeatureIndexesAndNames$Name,
            )
        
        theFeatureIndexesAndNames
    }

getTheActivityMasterData <-
    function()
    {
        theActivities  <-
            read.table(
                paste(
                    basePathOfTheData,
                    "activity_labels.txt",
                    
                    sep = ""
                ),
                
                header = FALSE,
                
                col.names =
                    c(
                        "Id",
                        "Name"
                    )
            )
        
        theActivities
    }