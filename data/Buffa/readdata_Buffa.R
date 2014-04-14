





workingDir ="D:/SAIA/Date/Buffa"
setwd(workingDir)


rm(list=ls(all=TRUE))
set.seed(321)

source("http://bioconductor.org/biocLite.R")

install.packages('mi')

library('mi')


data1 <- read.csv("Buffa_miroRNA_208_pacienti.csv",header = TRUE)


IMP <- mi(as.matrix(data1[,3:742]), n.iter=6, add.noise=FALSE)


# col 7 are multe missing values

clinical <- data1[,3:6] 

nfeat <- dim(data1)[2]

dataX <- as.matrix(data1[,8:(nfeat-2)])

relapse <-data1[,nfeat-1]

relapse_month <-data1[,nfeat]




write.table(dataX,"microRNA.xls",row.names=F,col.names=F,sep=",",quote=F)

write.table(clinical,"clinic.xls",row.names=F,col.names=F,sep=",",quote=F)

write.table(relapse,"relapse.xls",row.names=F,col.names=F,sep=",",quote=F)

write.table(relapse_month,"relapse_month.xls",row.names=F,col.names=F,sep=",",quote=F)


