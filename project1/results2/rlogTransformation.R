# Jason

# We will print regularized log2 transformed counts for the input genes.
# The transformation will include the ERCC normalization.
# Reads ERCC counts from <parameter1> e.g. ERCC/Cross.ColLer.Col_x_Col.csv
# Reads gene counts from <parameter2> e.g. At/Cross.ColLer.Col_x_Col.csv
# Writes normalized counts to log-transformed.<paramter1> e.g. log-transformed.Cross.ColLer.Col_x_Col.csv

args<-commandArgs(trailingOnly=TRUE)
ercc.counts<-args[1]
gene.counts<-args[2]
norm.counts<-paste("log-transformed", gene.counts, sep=".")

library("DESeq2")
#
# Read in raw read counts for control genes.
# Expect six values per line (1,2,3 same as 4,5,6).
##ERCC<-read.table("/local/ifs2_projdata/0716/projects/MOLBAR/ERCC92/Cross.ColLer.Col_x_Col.csv",header=FALSE,sep=",",skip=1)
ERCC<-read.table(ercc.counts,header=FALSE,sep=",",skip=1)
numERCC<-nrow(ERCC)
#
# Read in raw read counts for plant genes.
# Expect six values per line (e.g. Col,Col,Col,Ler,Ler,Ler) representing 3 replicates of 2 genotypes.
##RAW<-read.table("Cross.ColLer.Col_x_Col.csv",header=FALSE,skip=1,sep=",")
RAW<-read.table(gene.counts,header=FALSE,skip=1,sep=",")
#
# Combination of rows of control genes then rows of plant genes.
COMBINE<-rbind(ERCC,RAW)
#
# Build a DESeq2 data structure.
#    Remove the gene names, convert to matrix.
countdata<-as.matrix(COMBINE[,2:7])
#    Help R recognize the two factors (genotypes). Any words work here.
condition<-factor(c("Col","Col","Col","Ler","Ler","Ler"))
#    Use DESeq2 data structure to hold all the counts and metadata.
coldata<-data.frame(row.names=colnames(countdata),condition)
dds<-DESeqDataSetFromMatrix(countData=countdata,colData=coldata,design=~condition)
#
# Use DESeq2 to compute scaling factors for nomalization.
#    Warning: this includes ERCC and At rows that sum to zero.
#    Some sources recommend to remove rows that sum to zero; we tested & saw no difference with DESeq2.
#    This does not change the counts. It changes the size factors.
#    Failing to do this leads to an error with count(dds,normalization=TRUE).
#    Presumably, the factors get used by rlog() also.
#    Calling this makes a huge difference on rlog() results (regardless of rlog(blind) setting).
dds<-estimateSizeFactors(dds,type="ratio",controlGenes=1:numERCC)
#
# DESeq functions: rlog() regularized log2
#   uses library size, is unbiased on small counts
#   adds pseudocount=1 (so log=0) only to rows of all zero
#   takes DESeqDataSet, returns DESeqTransform
#   blind=FALSE allows function to use experimental design, recommmended for downstream analysis
#   reportedly, this does the ERCC normalization as part of the compute
#   Use log base 2 for all counts.
rldds<-rlog(dds,blind=FALSE)
nc<-assay(rldds)
#
# Pretty the matrix for printing.
#     Remove the ERCC counts (rows 1-92), which by now are also normalized.
nc<-nc[-(1:numERCC),]
#     Add back the column of gene IDs as row names.
#rownames(nc)<-RAW[,1]
nc<-cbind(data.frame(RAW[,1]),nc)
colnames(nc)<-c("gene","Col1","Col2","Col3","other1","other2","other3")
#
# Print.
write.table(nc,file=norm.counts,row.names=FALSE,col.names=TRUE,sep=",")


