# R script for ANOVA

my_data <- read.table(file="anova.input.csv",sep=",",header=TRUE)

anova <- aov(reads ~ cross * parent, data = my_data)

asum <- summary(anova)

write.csv(t(unlist(asum)),file="anova.output.csv")

