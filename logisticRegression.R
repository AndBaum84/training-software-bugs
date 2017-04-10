# Libraries
  library(e1071)
  library(mlogit)
  library(caret)
  library(ROCR)
  library(dummies)
  library(MASS)
  
# System parameters
  setwd(getSrcDirectory(function(x) {x}))
  rm(list = ls())
  # dev.off()

# Import test and train data
  t0 <- print(Sys.time())
  load("traindataset.RData")
  load("validationdataset.RData")
  load("testdataset.RData")

# Random Sampling to speed up development
#   train.dataset <- train.dataset[sample(nrow(train.dataset), 10000), ]
#   validation.dataset <- validation.dataset[sample(nrow(validation.dataset), 10000), ]
  train.dataset <- data.frame(train.dataset)
  validation.dataset <- data.frame(validation.dataset)
  
# Adjustment of Version entries to optimize glm computation  
  version.index <- c("D","Z",1,2,3,4,5,6,7,8)
  version.values <- c("D",0,1,2,3,4,5,6,7,8)
  train.dataset$VERSION <- version.index[match(substr(train.dataset$VERSION,1,1),version.values)]
  validation.dataset$VERSION <- version.index[match(substr(validation.dataset$VERSION,1,1),version.values)]
  
# Adjustment of Priority to optimize glm computation
  priority.index <- c(1,2,3,4,5,6)
  priority.values <- c("None","P1","P2","P3","P4","P5")
  train.dataset$PRIORITY <- priority.index[match(train.dataset$PRIORITY,priority.values)]
  validation.dataset$PRIORITY <- priority.index[match(validation.dataset$PRIORITY,priority.values)]
  
# Adjustment of OP_SYS to eliminate operating systems that do not occur frequently  
  train.dataset$OP_SYS[(train.dataset$OP_SYS %in% validation.dataset$OP_SYS)==FALSE]=NA
  validation.dataset$OP_SYS[(validation.dataset$OP_SYS %in% train.dataset$OP_SYS)==FALSE]=NA
    
# Adjustment of CURRENT_EMPLOYEE to eliminate new levels in logit prediction
  train.dataset$CURRENT_EMPLOYEE[(train.dataset$CURRENT_EMPLOYEE %in% validation.dataset$CURRENT_EMPLOYEE)==FALSE]=NA
  validation.dataset$CURRENT_EMPLOYEE[(validation.dataset$CURRENT_EMPLOYEE %in% train.dataset$CURRENT_EMPLOYEE)==FALSE]=NA

# Make dummy out of SUCCESS
  train.dataset$SUCCESS <- dummy(train.dataset$SUCCESS)[,1]
  validation.dataset$SUCCESS <- dummy(validation.dataset$SUCCESS)[,1]
  
# Convenience  
  quick <- train.dataset

# Logit Model estimation with training data
  logit <- glm( SUCCESS ~ 
                + CC_NUMBER
                + as.factor(OP_SYS)
                + as.factor(PRIORITY)
                + as.factor(SEVERITY)
                # + as.factor(CURRENT_EMPLOYEE)
                + as.factor(VERSION)
                + as.factor(STATUS)
                + as.factor(ASSIGNEE_NUMBER)
                # + as.factor(REPORTER)
                ,
                data = train.dataset ,  family = binomial(logit))
  summary(logit)
  print("model estimation complete")

# Prediction with validation data
  prob.logit <- predict(logit, validation.dataset, type = "response")

# Plot prediction results for validation dataset
  pred.logit<-prediction(prob.logit,validation.dataset$SUCCESS)
  perf<-performance(pred.logit, "tpr", "fpr")
  pdf("logit_validation.pdf",width=7,height = 5)
  plot(perf,main="Logit Regression (Validation) - ROC Curve",cex.main=1)
  abline(a=0, b= 1,lty=2, col="red")
  accuracy <- performance(pred.logit,"auc")
  slot(accuracy, "y.values")
  print("prediction computation complete")
  dev.off()
  plot(perf, main="Logit Regression (Validation) - ROC Curve",cex.main=1)
  abline(a=0, b= 1,lty=2,col="red")
  
# Export CSV with predictions per ID
  predictions <- data.frame(prob.logit)
  countNA <- sum(is.na(predictions))
  if(nrow(predictions)==nrow(validation.dataset)){
    predictions <- cbind(validation.dataset$ID,predictions)
    names(predictions)=c("ID","PROBABILITY_OF_BUG_BEING_SOLVED")
    } else {
    print("prediction error")
    }
  write.csv(predictions,file="logit_predictions.csv",row.names=FALSE)
  
  t1 <- print(Sys.time())
  print(t1-t0)


