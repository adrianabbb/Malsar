rm(list=ls(all=TRUE))


workingDir ="D:/SAIA/Pack_ada"
setwd(workingDir)


file1 = "data1/GSE31568_raw.txt" # date continand mai multe cancere

data1<- read.delim(paste(workingDir,file1,sep="/"), header = TRUE)
#setam denumirea variabilelor pe linii ca fiind denumirea miR-urilor
rownames(data1)=data1[,1]


#cream lista cu bolile care ne intereseaza: selectie include toate cazurile de interes minus cazul control
selectie=c("lung cancer","melanoma","ovarian cancer","pancreatic cancer ductal","prostate cancer","tumor of stomach")



#folosim cazul "control" pentru initializare (si acesta va intra in selectia facuta)
index=which(data1[1,] == "control")
for(i in 1:length(selectie))
{
  #extragem indecsii din prima linie data1 care se identifica cazul de interes (selectie[i]); atentie cand se preia codul, s-ar putea sa nu fie prima linia, ci o anumita linie sau coloana specificata prin string
  index_temp=which(data1[1,] == selectie[i])
  
  
  #adaugam la indexul existent noi indeci gasiti anterior
  index=c(index,index_temp)
} 

#extragem din date pozitiile cu bolile de interes
data1=data1[,index]

#cream vectorul status al bolii
data_temp=t(data1)
disease=data_temp[,"ID_REF"]

#indepartam coloana ID_REF
data1=t(data1)
data1=subset(data1,select = - c(ID_REF))

#adaugam statusul bolii la valorile de exprimare
data1=cbind(data1,disease)


# Pregateste fisiere separate

index = which(data1[,864] == "control")
for(i in 1:length(selectie))
{
  index_temp = which(data1[,864] == selectie[i])
  
  data_temp = data1[c(index,index_temp),]
  data_temp[which(data_temp[,864] == "control"),864] = 0
  data_temp[which(data_temp[,864] == selectie[i]),864] = 1
  
  write.table(data_temp,file=paste(selectie[i],"csv", sep="."),row.names=F,col.names=F,sep=",",quote=F)
} 


dim_data1 = dim(data1)
data_all <- cbind(data1[,1:863],1+numeric(dim_data1[1]))                             
data_all[which(data1[,864] == "control"),864] = 0;
write.table(data_all,"toate.csv",row.names=F,col.names=F,sep=",",quote=F)

