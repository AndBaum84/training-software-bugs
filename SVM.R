rm(list = ls())

library("e1071")
library("rpart")
library("penalizedSVM")
library("klaR")
library("RSofia")
library("kernlab")
library("ROCR")
library("dummies")
library("data.table")
library("plyr")
library("caret")
library("pROC")
#libsvm

###########DATA#######################################
######################################################

load("traindataset.RData")
load("validationdataset.RData")

###########TRAINING-DATA##############################

traindata <- data.frame(train.dataset$SUCCESS,train.dataset$CC_NUMBER,train.dataset$PRIORITY,train.dataset$SEVERITY,train.dataset$ASSIGNEE_NUMBER,train.dataset$VERSION,train.dataset$STATUS)

#traindata1 <- traindata[sample(nrow(traindata),40000),]
traindata1 <- traindata

traindata1$train.dataset.SUCCESS <- as.factor(traindata1$train.dataset.SUCCESS)

priority.index <- c(1,2,3,4,5,6)
priority.values <- c("None","P1","P2","P3","P4","P5")
traindata1$train.dataset.PRIORITY <- priority.index[match(traindata1$train.dataset.PRIORITY,priority.values)]
traindata1$train.dataset.PRIORITY <- as.numeric(traindata1$train.dataset.PRIORITY)

traindata1$train.dataset.CC_NUMBER <- as.numeric(traindata1$train.dataset.CC_NUMBER)

severity.index <- c(1,2,3,4,5,6,7)
severity.values <- c("enhancement","trivial","minor","normal","major","critical","blocker")
traindata1$train.dataset.SEVERITY <- severity.index[match(traindata1$train.dataset.SEVERITY,severity.values)]
traindata1$train.dataset.SEVERITY <- as.numeric(traindata1$train.dataset.SEVERITY)

traindata1$train.dataset.ASSIGNEE_NUMBER <- as.numeric(traindata1$train.dataset.ASSIGNEE_NUMBER)

traindata1$train.dataset.STATUS <- as.numeric(traindata1$train.dataset.STATUS)

version.index <- c(NA,"D","Z",1,2,3,4,5,6,7,8)
version.values <- c(0,0,0,1,2,3,4,5,6,7,8)
traindata1$train.dataset.VERSION <- version.index[match(substr(traindata1$train.dataset.VERSION,1,1),version.values)]
traindata1$train.dataset.VERSION <- as.numeric(traindata1$train.dataset.VERSION)

setnames(traindata1, "train.dataset.SUCCESS", "SUCCESS")
setnames(traindata1, "train.dataset.CC_NUMBER", "CC_NUMBER")
setnames(traindata1, "train.dataset.PRIORITY", "PRIORITY")
setnames(traindata1, "train.dataset.SEVERITY", "SEVERITY")
setnames(traindata1, "train.dataset.ASSIGNEE_NUMBER", "ASSIGNEE_NUMBER")
setnames(traindata1, "train.dataset.VERSION", "VERSION")
setnames(traindata1, "train.dataset.STATUS", "STATUS")

###########VALIDATION-DATA############################

validationdata <- data.frame(validation.dataset$SUCCESS,validation.dataset$CC_NUMBER,validation.dataset$PRIORITY,validation.dataset$SEVERITY,validation.dataset$ASSIGNEE_NUMBER,validation.dataset$VERSION,validation.dataset$STATUS)

#validationdata1 <- validationdata[sample(nrow(validationdata),20000),]
validationdata1 <- validationdata

validationdata1$validation.dataset.SUCCESS <- as.factor(validationdata1$validation.dataset.SUCCESS)

validationdata1$validation.dataset.PRIORITY <- priority.index[match(validationdata1$validation.dataset.PRIORITY,priority.values)]
validationdata1$validation.dataset.PRIORITY <- as.numeric(validationdata1$validation.dataset.PRIORITY)

validationdata1$validation.dataset.CC_NUMBER <- as.numeric(validationdata1$validation.dataset.CC_NUMBER)

validationdata1$validation.dataset.SEVERITY <- severity.index[match(validationdata1$validation.dataset.SEVERITY,severity.values)]
validationdata1$validation.dataset.SEVERITY <- as.numeric(validationdata1$validation.dataset.SEVERITY)

validationdata1$validation.dataset.ASSIGNEE_NUMBER <- as.numeric(validationdata1$validation.dataset.ASSIGNEE_NUMBER)

validationdata1$validation.dataset.STATUS <- as.numeric(validationdata1$validation.dataset.STATUS)

validationdata1$validation.dataset.VERSION <- version.index[match(substr(validationdata1$validation.dataset.VERSION,1,1),version.values)]
validationdata1$validation.dataset.VERSION <- as.numeric(validationdata1$validation.dataset.VERSION)

setnames(validationdata1, "validation.dataset.SUCCESS", "SUCCESS")
setnames(validationdata1, "validation.dataset.CC_NUMBER", "CC_NUMBER")
setnames(validationdata1, "validation.dataset.PRIORITY", "PRIORITY")
setnames(validationdata1, "validation.dataset.SEVERITY", "SEVERITY")
setnames(validationdata1, "validation.dataset.ASSIGNEE_NUMBER", "ASSIGNEE_NUMBER")
setnames(validationdata1, "validation.dataset.VERSION", "VERSION")
setnames(validationdata1, "validation.dataset.STATUS", "STATUS")

validationdata1 <- na.omit(validationdata1)

###########SUPPORT-VECTOR-MACHINE(KERNLAB)############
######################################################
# SIMPLE: 
# ALTERNATIVE: scaled = TRUE, type = "C-svc", kernel ="rbfdot", kpar = "automatic", C = 1, nu = 0.2, epsilon = 0.1, prob.model = FALSE, class.weights = NULL, cross = 0, fit = TRUE, cache = 40, tol = 0.001, shrinking = TRUE, subset, na.action = na.omit
######################################################

#fit <- ksvm(SUCCESS ~ PRIORITY+CC_NUMBER+SEVERITY+ASSIGNEE_NUMBER+VERSION+STATUS, data = traindata1, prob.model = T, C = 20, nu = 0.25, epsilon = 0.1, na.action = na.omit)
fit <- ksvm(SUCCESS~., data = traindata1, type="C-svc", kernel = "rbfdot", kpar = list(sigma = 0.05), C = 20, prob.model = T, na.action = na.omit)

#summary(fit)
#attributes(fit)

###########PREDICTION#################################
######################################################

pred.model <- predict(fit, newdata=validationdata1[,-1], type = "prob")
head(pred.model)

###########PLOT SVM###################################
######################################################

plot.roc(validationdata1$SUCCESS, pred.model[,2], "l", col="red", percent=T,
         main = "Support Vector Machine (Validation) - ROC Curve")

###########WRITE SVM PREDICTIONS######################
######################################################
validationdata2 <- data.frame(validation.dataset$ID,validation.dataset$SUCCESS,validation.dataset$CC_NUMBER,validation.dataset$PRIORITY,validation.dataset$SEVERITY,validation.dataset$ASSIGNEE_NUMBER,validation.dataset$VERSION,validation.dataset$STATUS)

#validationdata1 <- validationdata[sample(nrow(validationdata),20000),]
validationdata3 <- validationdata2

validationdata3$validation.dataset.ID <- as.numeric(validationdata3$validation.dataset.ID)

validationdata3$validation.dataset.SUCCESS <- as.factor(validationdata3$validation.dataset.SUCCESS)

validationdata3$validation.dataset.PRIORITY <- priority.index[match(validationdata3$validation.dataset.PRIORITY,priority.values)]
validationdata3$validation.dataset.PRIORITY <- as.numeric(validationdata3$validation.dataset.PRIORITY)

validationdata3$validation.dataset.CC_NUMBER <- as.numeric(validationdata3$validation.dataset.CC_NUMBER)

validationdata3$validation.dataset.SEVERITY <- severity.index[match(validationdata3$validation.dataset.SEVERITY,severity.values)]
validationdata3$validation.dataset.SEVERITY <- as.numeric(validationdata3$validation.dataset.SEVERITY)

validationdata3$validation.dataset.ASSIGNEE_NUMBER <- as.numeric(validationdata3$validation.dataset.ASSIGNEE_NUMBER)

validationdata3$validation.dataset.STATUS <- as.numeric(validationdata3$validation.dataset.STATUS)

validationdata3$validation.dataset.VERSION <- version.index[match(substr(validationdata3$validation.dataset.VERSION,1,1),version.values)]
validationdata3$validation.dataset.VERSION <- as.numeric(validationdata3$validation.dataset.VERSION)

setnames(validationdata3, "validation.dataset.ID", "ID")
setnames(validationdata3, "validation.dataset.SUCCESS", "SUCCESS")
setnames(validationdata3, "validation.dataset.CC_NUMBER", "CC_NUMBER")
setnames(validationdata3, "validation.dataset.PRIORITY", "PRIORITY")
setnames(validationdata3, "validation.dataset.SEVERITY", "SEVERITY")
setnames(validationdata3, "validation.dataset.ASSIGNEE_NUMBER", "ASSIGNEE_NUMBER")
setnames(validationdata3, "validation.dataset.VERSION", "VERSION")
setnames(validationdata3, "validation.dataset.STATUS", "STATUS")

validationdata3 <- na.omit(validationdata3)

predictions <- cbind(validationdata3$ID, pred.model[,2])
write.csv(predictions, file = "PredictionsSVM.csv")
