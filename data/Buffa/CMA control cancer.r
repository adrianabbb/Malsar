source("http://bioconductor.org/biocLite.R")
biocLite("CMA")


library(CMA)
setwd("c:/Users/PAUL/Documents/R/")
data1 <- read.csv("GSE31568_VSN_control_cancer.csv",header = TRUE)
dim(data1)
dataX <- as.matrix(data1[,1:863])
 dataY <-data1[,864]
 loodat <- GenerateLearningsets(y=dataY, method ="LOOCV")
 class(loodat)
 getSlots(class(loodat))
 show(loodat)
 set.seed(321)
 fiveCVdat <- GenerateLearningsets(y=dataY, method = "CV", fold = 20, strat = TRUE)
 set.seed(456)
 MCCVdat <- GenerateLearningsets(y=dataY, method = "MCCV", niter = 20, ntrain = floor(2/3*length(dataY)), strat = TRUE)
 set.seed(651)
 bootdat <- GenerateLearningsets(y=dataY, method = "bootstrap", niter = 20, strat = TRUE)
 varsel_fiveCV <- GeneSelection(X = dataX, y=dataY, learningsets = fiveCVdat, method = "rfe")
 varsel_MCCV <- GeneSelection(X = dataX, y=dataY, learningsets = MCCVdat, method = "rfe")


 varsel_boot <- GeneSelection(X = dataX, y= dataY, learningsets = bootdat, method = "rfe")

show(varsel_fiveCV)

 toplist(varsel_fiveCV, iter=1)

  seliter <- numeric()
 for(i in 1:20) seliter <- c(seliter, toplist(varsel_fiveCV, iter = i, top = 10, show = TRUE)$index)

 sort(table(seliter), dec = TRUE)


 set.seed(351) 
      tuningstep <- CMA:::tune(X = dataX, y= dataY, learningsets = fiveCVdat, genesel = varsel_fiveCV, nbgene = 100, classifier = svmCMA, grids = list(cost = c(0.1, 1, 10, 100, 200)),probability=T)
 show(tuningstep)

 unlist(best(tuningstep))

 par(mfrow = c(2,2))
 for(i in 1:20) plot(tuningstep, iter = i, main = paste("iteration", i))
      class_loo <- classification(X = dataX, y= dataY, learningsets = loodat,  genesel = varsel_loo, nbgene = 100, classifier = svmCMA,  cost = 100)

      class_fiveCV <- classification(X = dataX, y= dataY, learningsets = fiveCVdat, genesel = varsel_fiveCV, nbgene = 100, classifier = svmCMA,cost = 0.1,probability=T)

      class_MCCV <- classification(X = dataX, y= dataY, learningsets = MCCVdat, genesel = varsel_MCCV, nbgene = 100, classifier = svmCMA,cost = 0.1,probability=T)

      class_boot <- classification(X = dataX, y= dataY, learningsets = bootdat, genesel = varsel_boot, nbgene = 0.1, classifier = svmCMA,cost = 100,probability=T)

 resultlist <- list(class_fiveCV, class_MCCV, class_boot)
 result <- lapply(resultlist, join)
 schemes <- c("five-fold CV", "MCCV", "bootstrap")
 par(mfrow = c(3,1))
 for(i in seq(along = result)) plot(result[[i]], main = schemes[i])
 invisible(lapply(result, ftable))


 par(mfrow = c(2,2))
 for(i in seq(along = result)) roc(result[[i]])
 totalresult <- join(result)
 ftable(totalresult)


 av_MCCV <- evaluation(class_MCCV, measure = "average probability")
 show(av_MCCV)

 boxplot(av_MCCV)
 summary(av_MCCV)

 av_obs_MCCV <- evaluation(class_MCCV, measure = "average probability", scheme = "obs")
 show(av_obs_MCCV)

 obsinfo(av_obs_MCCV, threshold = 0.6)


