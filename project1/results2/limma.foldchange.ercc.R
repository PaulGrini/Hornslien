library(methods)

# Input: ERCC normalized values. (Possibly rlog normalized.)
# Apply: Normalize, get fold change, get P-value.

args<-commandArgs(trailingOnly=TRUE)
gene.counts<-paste(args[1], "csv", sep=".")
gene.sigs<-paste(args[1], "sig", sep=".")

# Get rid of column 1 which as the gene names
dax=read.csv(gene.counts, header=TRUE, sep=",")
da=as.matrix(dax[,2:7])

# Get rid of zeros.
# No need to do this if rlog normalization was already applied.
pseudocount=0.01
da<-log2(da+as.numeric(pseudocount))

library(limma)
Group <- factor(c("Col","Col","Col","other","other","other"))
design <- model.matrix(~0 + Group)
colnames(design) <- c("Col","other")
fit <- lmFit(da[,1:6],design)
contrast.matrix<-makeContrasts(Col-other, levels=design)
fit2<-contrasts.fit(fit,contrast.matrix)
fit2<-eBayes(fit2)
result1<-topTable(fit2,number=1011)

library(gtools)
x<-logratio2foldchange(result1$logFC, base=2)
res1<-cbind(result1,x)
write.csv(res1,gene.sigs)
