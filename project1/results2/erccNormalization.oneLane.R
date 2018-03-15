# Jason

# We will print ERCC-normalized counts for the input genes.
# We will write normalized counts to ERCC-normalized.<paramter1> 

# Reads ERCC counts from <parameter1> 
# The ERCC count is repeated 3 for cross1 and 3 for cross2.
# In this example, ERCC levels in cross2 were twice as high.
# ERCC-00002 10 10 10 20 20 20
# ERCC-00003 0 0 0 5 5 5
	    
# Reads gene counts from <parameter2> 
# The DATA count is repeated 3 for cross1 and 3 for cross2.
# In this example, the gene levels in cross2 were twice as high.
# AT1G01530.1 110 105 115 210 205 215

#
# Import libraries and parse command line arguments.
#
args<-commandArgs(trailingOnly=TRUE)
ercc.counts<-args[1]
gene.counts<-args[2]
norm.counts<-paste("ERCC-normalized", gene.counts, sep=".")
library("DESeq2")

#
# Read in raw read counts for ERCC genes.
# For input file with multi-space delimiters, omit the sep parameter.
# For input files with a header line, include the skip parameter.
#
ERCC<-read.table(ercc.counts,header=FALSE)
numERCC<-nrow(ERCC)

#
# Read in raw read counts for plant genes.
#
RAW<-read.table(gene.counts,header=FALSE)

#
# Combination of rows of control genes then rows of plant genes.
#
COMBINE<-rbind(ERCC,RAW)

#
# Build a DESeq2 data structure.
#
#    Remove the gene names column and convert to matrix.
#
countdata<-as.matrix(COMBINE[,2:7])

#
#    Help R recognize the two factors (genotypes).
#    It does not matter if the genotypes are actually "Col","Tsu".
#
condition<-factor(c("Col","Col","Col","Ler","Ler","Ler"))
#
#    Use DESeq2 data structure to hold all the counts and metadata.
#
coldata<-data.frame(row.names=colnames(countdata),condition)
dds<-DESeqDataSetFromMatrix(countData=countdata,colData=coldata,design=~condition)

#
# Use DESeq2 to compute scaling factors for nomalization.
#
#    Warning: this includes ERCC and At rows that sum to zero.
#    Test if results improve by removing these.
#    This does not change the counts. It changes the size factors.
#    Failing to do this leads to an error with count(dds,normalization=TRUE).
#    Presumably, the factors get used by rlog() also.
#    Calling this makes a huge difference on rlog() results (regardless of rlog(blind) setting.
#    Some sources recommend to remove rows that sum to zero.
#    We tested & saw no difference with DESeq2.
#    This assumes that the true values for the control genes are the same in all columns.
#    When this sees values higher in one column, it will discount all counts in that column.
#
dds<-estimateSizeFactors(dds,type="ratio",controlGenes=1:numERCC)

#
# Generate normalized counts as (raw count) / (scaling factor)
#
nc<-counts(dds, normalized=TRUE)

#
# Pretty the matrix for printing.
#
#     Remove the ERCC counts (rows 1-92), which by now are also normalized.
nc<-nc[-(1:numERCC),]
#
#     Add back the column of gene IDs as row names.
#rownames(nc)<-RAW[,1]
nc<-cbind(data.frame(RAW[,1]),nc)
colnames(nc)<-c("gene","Col","other")

#
# Print.
#
write.table(nc,file=norm.counts,row.names=FALSE,col.names=FALSE,sep=",")

