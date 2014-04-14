
rm(list=ls(all=TRUE))


workingDir ="D:/SAIA/Date/Buffa"
setwd(workingDir)

source("http://bioconductor.org/biocLite.R")
library(GEOquery)
library(stringr)

gse <- getGEO('GSE22220', destdir=workingDir)

cat("Data loaded! \n")

mRNA <- exprs(gse[[1]])
microRNA <- exprs(gse[[2]])

dim_microRNA <- dim(microRNA)

relapse <- matrix(0,ncol=dim_microRNA[2],nrow=1)
for(k in 1:dim_microRNA[2]){
        # setul 2 contine mRNA-uri
        x <- Meta(getGEO(sampleNames(phenoData(gse[[2]]))[k]))
        #show(x$characteristics_ch1[7])
        relapse[k] <- as.numeric(str_sub(x$characteristics_ch1[7], 24))
   }
relapse <- as.numeric(relapse)

cat("Relased variable read! \n")
cat("====================== \n")

 # Make the correspondance between microRNA and mRNA sample patients
fid <- file("GSE22220_miRNA_mRNA_sample_associations.txt", "r")
open(fid)
assoc_matrix <- matrix(0,ncol=2,nrow=207)
currentline <- 1
imat <- 1
while (length(line <- readLines(fid, n = 1, warn = FALSE)) > 0) {
    assoc <- strsplit(line, split="\t")
    x1 <-  strsplit(assoc[[1]][1], split=" ")

    if (nchar(assoc[[1]][1]) > 2){
    if (nchar(assoc[[1]][2]) > 2){
        x2 <-  strsplit(assoc[[1]][2], split=" ")
        assoc_matrix[imat,1] <- as.integer(x1[[1]][2])
        assoc_matrix[imat,2] <- as.integer(x2[[1]][2])
        imat <- imat + 1
     }
     }
 currentline <- currentline + 1
}
close(fid)
microRNA<-microRNA[,assoc_matrix[,2]]
mRNA<-mRNA[,assoc_matrix[,1]]
relapse <- relapse[assoc_matrix[,2]]
cat("Correspondance between  microRNA and mRNA sample patients made! \n")
cat("====================== \n")

# mRNA names mapping
mRNA_mapping <- read.csv(file="GPL6098_Illumina_Human_RefSeq-8_V1.csv",head=TRUE,sep=",")

mRNA_nr_orig <- rownames(mRNA)
mRNA_nr_table <- mRNA_mapping[,3]
mRNA_to_replace <- mRNA_mapping[,1]  # replace with the first column (Search_key)/.Pentru a selecta alta colana se schimba 1 cu nr colanei

dim_mRNA <- dim(mRNA)
ngenes = dim_mRNA[1]
mRNA_new_names <- matrix(0,ncol=1,nrow=ngenes)
k <- 1
     while (k <= ngenes){              
        mRNA_new_names[k] <- toString(mRNA_to_replace[which(mRNA_nr_orig[k]==mRNA_nr_table)])
        k <- k+1
      }
row.names(mRNA) <- mRNA_new_names    
cat("mRNA names mapped! \n")
cat("====================== \n")


source("http://www.bioconductor.org/biocLite.R")
biocLite()
library(genefilter)
cat("Bioconductor libraries loaded! \n")
cat("====================== \n")

# Apply standard deviation filter
rsd <-rowSds(mRNA);
mRNA_filter <-mRNA[i<-rsd>=1.5,]; 
rsd_microRNA<-rowSds(microRNA);
microRNA_filter <-microRNA[i<-rsd_microRNA>=1.5,];
cat("Filter applied! \n")
cat("====================== \n") 


# Apply pOverA filter
ff<-pOverA(p=0.2, A=15);i<-genefilter(microRNA, ff);microRNA_filter2<-microRNA[i,]; dim(microRNA_filter2)
ff<-pOverA(p=0.2,A=14);
ii<-genefilter(mRNA, ff); 
mRNA_filter2<-mRNA[ii,]; 
file_MINE_std <- "miR_mRNA_folds.csv"
write.table(rbind(microRNA_filter2,mRNA_filter2),file_MINE_std ,sep=",", col.names = F)
cat("Filter applied! \n")
cat("====================== \n")


# Apply specific filter
f2_relapse <- ttest(relapse, p=0.01)
i3 <- genefilter(microRNA, filterfun(f2_relapse)); sum(i3)
microRNA_filter3<-microRNA[i3,]; 
f2_relapse <- ttest(relapse, p=0.0005)
i3 <- genefilter(mRNA, filterfun(f2_relapse)); sum(i3)
mRNA_filter3 <- mRNA[i3,]
write.table(rbind(microRNA_filter3,mRNA_filter3), "miR_mRNA_specificfilter.csv" ,sep=",", col.names = F)
cat("Filter applied! \n")
cat("====================== \n")


# Separate into 2 groups: relapsed and no_relapsed
indx_1 <- which(relapse == 1)
indx_0 <- which(relapse == 0)

mRNA_relapsed <- mRNA[,indx_1]
mRNA_no_relapsed <- mRNA[,indx_0]

microRNA_relapsed <- microRNA[,indx_1]
microRNA_no_relapsed <- microRNA[,indx_0]

file_MINE_std <- "miR_mRNA_all_relapsed.txt"
write.table(rbind(mRNA_relapsed,microRNA_relapsed),file_MINE_std ,sep=",", col.names = F,row.names=F)

file_MINE_std <- "miR_mRNA_all_no_relapsed.txt"
write.table(rbind(mRNA_no_relapsed,microRNA_no_relapsed),file_MINE_std ,sep=",", col.names = F,row.names=F)


write.table(c(row.names(mRNA),row.names(microRNA)),"mRNA_microRNA_names.txt" ,sep=",", col.names = F,row.names=F)


cat("Samples re-grouped! \n")
cat("====================== \n")

source("MINE.R")
MINE(file_micMine,"all.pairs")