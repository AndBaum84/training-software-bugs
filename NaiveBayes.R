# Load relevant packages
rm(list = ls())
library("stringr")
library("RSQLite")
library("DBI")
library("dummies")
library("e1071")
library(caret)
library(ROCR)

######################################
# Loading the data for the model
######################################

load("wholedataset.RData")
load("nonedataset.RData")
load("traindataset.RData")
load("testdataset.RData")
load("validationdataset.RData")

# Creating a fixed dummy

A <- dummy(train.dataset$SUCCESS)
B <- A[,1]

C <- dummy(validation.dataset$SUCCESS)
D <- C[,1]



model <- naiveBayes(B ~  CC_NUMBER + CURRENT_EMPLOYEE + OP_SYS + PRIORITY 
                    + VERSION + SEVERITY + SUBSYSTEM + as.factor(STATUS) + as.factor(REPORTER) + as.factor(ASSIGNEE_NUMBER), 
                    data = train.dataset, na.action = na.pass)

sample <- length(validation.dataset$SUCCESS)
predict(model, validation.dataset[1:sample,], type = "raw") 
pred.naive <- predict(model, validation.dataset,type = "raw") 




pred <- prediction(pred.naive[,2], D)
perf <- performance(pred,"tpr","fpr")
pdf("GraphBayes.pdf",width=7,height=5)
plot(perf, main = "Naive Bayes Classfier (Validation) -ROC Curve")
abline(a=0, b= 1,lty=2, col='red')
dev.off()
accuracy <- performance(pred,"auc")
slot(accuracy, "y.values")


# Prediction for the validation dataset

predictions <- cbind(validation.dataset$ID, pred.naive[,2])
write.csv(predictions, file = "PredictionsNaiveBayes.csv")

####################################################################
