# Load relevant packages
rm(list = ls())
library("stringr")
library("RSQLite")
library("DBI")
library("dummies")

######################################################
########### Function definitions #####################
######################################################

RunSQLiteQuery <- function(database, query){
# Us the bulit-in functions from RSQLite package to execute 
# supplied query against an existing SQLite database, and 
# return the results in a data frame.

require(RSQLite)
connection <- dbConnect(RSQLite::SQLite(), dbname = database)
query.object <- dbSendQuery(connection, query)
query.data <- fetch(query.object, n = -1)
return(query.data)
}


####################################################
# Load the data from the BugDatabase.db ############
####################################################

# Dataset Fixed/ WONTFIX
query.whole <- readChar("JoinWholeData.sql", file.info("JoinWholeData.sql")[["size"]])

whole.dataset <-RunSQLiteQuery("BugDatabase.db", query.whole) 

# Dataset NONE
query.none <- readChar("JoinWholeData_None.sql", file.info("JoinWholeData_None.sql")[["size"]])

none.dataset <-RunSQLiteQuery("BugDatabase.db", query.none) 

# Count the number of persons who want to be informed about the bug
cc_clean_number <- str_count(whole.dataset$CC_WHO, "@")
# Update the dataframe
whole.dataset["CC_NUMBER"] <- cc_clean_number
# Count the number of persons who want to be informed about the bug
cc_clean_number_none <- str_count(none.dataset$CC_WHO, "@")
# Update the dataframe
none.dataset["CC_NUMBER"] <- cc_clean_number_none

#################################################
#### Define Dummies for succes/ nonsuccess #####
################################################

# The dummy are the variable success
success.whole <- as.factor(whole.dataset$CURRENT_RESOLUTION)
success.none <- as.factor(whole.dataset$CURRENT_RESOLUTION) 

whole.dataset["SUCCESS"] <- success.whole
none.dataset["SUCCESS"] <- success.none


###############################################
#### Spliting the whole dataset into training,
#### validation and testing datasets 
###############################################


## 50% of the whole dataset for training
smp_size <- floor(0.5 * nrow(whole.dataset))

## Set seed
set.seed(1045)

## Split sample into train & nontrain data
train_id <- sample(seq_len(nrow(whole.dataset)), size = smp_size)

train.dataset <- whole.dataset[train_id, ]
non.train.dataset <- whole.dataset[-train_id, ]

## 50% of the non.train.dataset for testing and 50% for validation
smp_size2 <- floor(0.5 * nrow(non.train.dataset))

## Set seed
set.seed(15677)

## Split the non_train data for testing and validation
non.train.id <- sample(seq_len(nrow(non.train.dataset)), size = smp_size2)

test.dataset <- non.train.dataset[non.train.id, ]
validation.dataset<- non.train.dataset[-non.train.id, ]


# save the datasets
save(whole.dataset, file = "wholedataset.RData")
save(none.dataset, file = "nonedataset.RData")
save(train.dataset, file = "traindataset.RData")
save(test.dataset, file = "testdataset.RData")
save(validation.dataset, file = "validationdataset.RData")