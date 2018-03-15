library(methods)

# Input: ERCC normalized values. (Possibly rlog normalized.)
# Apply: Normalize, get fold change, get P-value.

args<-commandArgs(trailingOnly=TRUE)
gene.counts<-paste(args[1], "csv", sep=".")
gene.sigs<-paste(args[1], "sig", sep=".")

# Get rid of column 1 which as the gene names
dax=read.csv(gene.counts, header=FALSE, sep=",")
da=as.matrix(dax[,2:7])

# Get rid of zeros.
# No need to do this if rlog normalization was already applied.
pseudocount=1.0
da<-log2(da+as.numeric(pseudocount))

library(limma)
# Use limma to compute P-values.
Group <- factor(c("Col","Col","Col","other","other","other"))
design <- model.matrix(~0 + Group)
colnames(design) <- c("Col","other")
fit <- lmFit(da[,1:6],design)    # fit a linear model
contrast.matrix<-makeContrasts(Col-other, levels=design)  # contains "Col - other"
fit2<-contrasts.fit(fit,contrast.matrix)
# After fit, rows are numbered and columns are...
# "","coefficients","df.residual","sigma","stdev.unscaled","Amean"
fit2<-eBayes(fit2)
# After eBayes, Columns are...
# "","coefficients","df.residual","sigma","stdev.unscaled","Amean","s2.post","t","df.total","p.value","lods","F","F.p.value"
result1<-topTable(fit2,number=1011)
# limma topTable: Extract a table of the top-ranked genes from a linear model fit.
# After topTable rows are sorted by P-Value and columns are...
# "","logFC","AveExpr","t","P.Value","adj.P.Val","B","x"
# Note the table does not include gene name.

library(gtools)   
# Use gtools to compute fold change.
# http://ftp.auckland.ac.nz/software/CRAN/doc/packages/gtools.pdf
# This library has functions for regular fold change and log fold change.
## The base used to be required but the current version complains about it.
# x<-logratio2foldchange(result1$logFC, fbase=2)  # old version
x<-logratio2foldchange(result1$logFC)
res1<-cbind(result1,x)  # tack on fold change as the last column
write.csv(res1,gene.sigs)
