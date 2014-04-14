
setwd("C:/Users/ibm/Desktop/Ada-work")

if(0==1)
{

library(CMA)
library(e1071)
#library(randomForest)
library(plsgenomics)
library(glmnet)
library(limma)
library(st)
library(imputation) 
}

rm(list=ls(all=TRUE))
set.seed(321)

data1 <- read.csv("Buffa_miroRNA_208_pacienti.csv",header = TRUE)

p <- kNNImpute(as.matrix(data1[,3:742]),4)
data_impute <- p$x

clinical <- data_impute[,1:5]
dataX <- as.matrix(data_impute[,6:(dim(data_impute)[2])])

#clinical <- data1[,3:6]
#dataX <- as.matrix(data1[,8:742])
dataY <-data1[,743]


niter1 <- 10
fiveCVdat <- GenerateLearningsets(y=dataY, method = "CV", fold=10, niter=niter1, strat = TRUE)


fs_methods<-c("lasso","shrinkcat","wilcox.test","elasticnet")#"t.test", "welch.test", "wilcox.test", "f.test", "kruskal.test", "limma", "rfe", "rf", "lasso", "elasticnet", "boosting", "golub", "shrinkcat")


nbgene1 <- seq(5,100,5) #c(5,10,20,50,100,200)

results <-matrix(nrow=4*length(fs_methods)*length(nbgene1),ncol=10)

iline <- 0
for (i in 1:length(fs_methods))
{
    varsel <- GeneSelection(X = dataX, y=dataY, learningsets = fiveCVdat, method = fs_methods[i],trace=FALSE)

    for (nr in 1:length(nbgene1))
        {
 
         cat("====================  la nbgene1 =======================================",nr)
          ###clasificare cu date clinice adaugate dupa selectie
          #####################################selectia genelor din 10 iteratii
          matrix_scores <-matrix(nrow=dim(dataX)[2],ncol=niter1) 
      
          for (j in 1:niter1)
            {     
              matrix_temp <-matrix(nrow=dim(dataX)[2],ncol=2)
              matrix_temp<-toplist(varsel, k = dim(dataX)[2], iter = j)    
              matrix_temp<-matrix_temp[order(matrix_temp[,1]),]
     
              matrix_scores[,j] <- matrix_temp[,2]
            }    
          
          index <- tail(order(rowSums(matrix_scores)),n=nbgene1[nr])  
          
          data_new <-dataX[,index]
          dataX_new <-as.matrix(cbind(clinical,data_new))
 
          #######
          
          #class_svm_clinic <- classification(X = dataX_new, y=dataY, learningsets = fiveCVdat,classifier = svmCMA, strat=TRUE,probability=T)
          
          #svm kernel liniar
          tuningstep_clinic1 <- CMA:::tune(X = dataX_new, y=dataY, learningsets = fiveCVdat, classifier = svmCMA, trace=FALSE, grids = list(cost = c(0.01, 0.1, 1, 10, 100),epsilon=c(0.01,0.1,1,10)),strat=TRUE,probability=T)
          class_svm_clinic1 <- classification(X = dataX_new, y=dataY, learningsets = fiveCVdat,classifier = svmCMA, trace=FALSE, tuneres = tuningstep_clinic1,strat=TRUE,probability=T)
          
          
          #svm kernel radial

     #     tuningstep_clinic2 <- CMA:::tune(X = dataX_new, y=dataY, learningsets = fiveCVdat, classifier = svmCMA, kernel = "radial", grids = list(cost = c(0.01, 0.1, 1, 10, 100),gamma = c(2^{-2:2},1/735)),strat=TRUE,probability=T)
     #     class_svm_clinic2 <- classification(X = dataX_new, y=dataY, learningsets = fiveCVdat,classifier = svmCMA, kernel = "radial",tuneres = tuningstep_clinic2,strat=TRUE,probability=T)
          
          #svm kernel polynomial
     #     tuningstep_clinic3 <- CMA:::tune(X = dataX_new, y=dataY, learningsets = fiveCVdat, classifier = svmCMA, kernel = "polynomial", grids = list(cost = c(0.01, 0.1, 1, 10, 100),gamma = c(2^{-2:2},1/735),degree = 2:5, coef0=c(0,1,2)),strat=TRUE,probability=T)
      #    class_svm_clinic3 <- classification(X = dataX_new, y=dataY, learningsets = fiveCVdat,classifier = svmCMA, kernel = "polynomial",tuneres = tuningstep_clinic3,strat=TRUE,probability=T)
          
          #svm kerne sigmoid
     #     tuningstep_clinic4 <- CMA:::tune(X = dataX_new, y=dataY, learningsets = fiveCVdat, classifier = svmCMA, kernel = "sigmoid", grids = list(cost = c(0.01, 0.1, 1, 10, 100), gamma = c(2^{-2:2},1/735),coef0=c(0,1,2)),strat=TRUE,probability=T)
     #     class_svm_clinic4 <- classification(X = dataX_new, y=dataY, learningsets = fiveCVdat,classifier = svmCMA, kernel = "sigmoid",tuneres = tuningstep_clinic4,strat=TRUE,probability=T)
          
          #############

          resultlist <- list(class_svm_clinic1)
          result <- lapply(resultlist, join)
          invisible(lapply(result, ftable))
          auc1<- roc(result[[1]],plot=FALSE)
   
      #    resultlist2 <- list(class_svm_clinic2)
      #    result2 <- lapply(resultlist2, join)
      #    invisible(lapply(result2, ftable))
      #    auc2<- roc(result2[[1]],plot=FALSE)
          
      #    resultlist4 <- list(class_svm_clinic4)
      #    result4 <- lapply(resultlist4, join)
      #    invisible(lapply(result4, ftable))
      #    auc4 <- roc(result4[[1]],plot=FALSE)
       
       
           av_fiveCV_clinic1 <- evaluation(class_svm_clinic1, measure = "misclassification")
      #     av_fiveCV_clinic2 <- evaluation(class_svm_clinic2, measure = "misclassification")
      #     av_fiveCV_clinic4 <- evaluation(class_svm_clinic4, measure = "misclassification")
        
          
           iline <-iline + 1
           results[iline,1] <- fs_methods[i];
           results[iline,2] <- nbgene1[nr];
           results[iline,3] <- auc1;
           results[iline,4] <- summary(av_fiveCV_clinic1)[4];
       
       #    results[iline,5] <- auc2;
       #    results[iline,6] <- summary(av_fiveCV_clinic2)[4];
       #    results[iline,7] <- auc4;
       #    results[iline,8] <- summary(av_fiveCV_clinic4)[4]; 
           
      }
 }
write.matrix(results, file="18feb_02.txt", sep="\t")


