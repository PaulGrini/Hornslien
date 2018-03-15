library(methods)

# Expect 7 columns per line: gene Col Col Col other other other
# Three replicates of two conditions.

args<-commandArgs(trailingOnly=TRUE)
gene.counts<-args[1]
gene.sigs<-paste(args[1], "de", sep=".")

dax=read.table(gene.counts, header=FALSE)
#da=data.matrix(dax)
#da=dax
pseudocount=1.0 # 0.01 gave astronomical fold changes
da<-log2(dax[,2:7]+pseudocount)

library(limma)
Group <- factor(c("Col","Col","Col","other","other","other"))
design <- model.matrix(~0 + Group)
colnames(design) <- c("Col","other")
fit <- lmFit(da[,1:6],design)
#fit <- lmFit(da[,2:7],design)
contrast.matrix<-makeContrasts(Col-other, levels=design)
fit2<-contrasts.fit(fit,contrast.matrix)
fit2<-eBayes(fit2)
result1<-topTable(fit2,number=1011)

library(gtools)
x<-logratio2foldchange(result1$logFC, base=2)
res1<-cbind(result1,x)
write.csv(res1,gene.sigs)

# The output is missing the gene name but the first column is the ordinal of the original row.
# cat outfile | tr -d '"' | sort -k1,1n
# Then paste to the input file.