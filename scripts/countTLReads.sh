#!/bin/bash

# Count telomeric content in reads

cramFile=$1
craiFile=$2
outputFile=$3

sample=$(samtools samples $cramFile)

awk -v OFS='\t' 'BEGIN {print "Count","RepeatK","Sample","Cram"}' |gzip> $outputFile


samtools view -h $cramFile \
| awk -v OFS='\t'  -v readIndex=10 \
'{k1=gsub(/CCCTAA/, "CCCTAA",$readIndex);k2=gsub(/TTAGGG/, "TTAGGG",$readIndex)}{if(k1 >= k2){print k1} else {print k2}}' \
|sort |uniq -c |awk -v sample=$sample -v OFS='\t' -v IFS=' ' '{print $1,$2,sample}' |gzip >> $outputFile
