#!/bin/bash

input="input.txt"
sum=0
while IFS= read -r line
do
    s1=${line//"one"/"one1one"}
    s2=${s1//"two"/"two2two"}
    s3=${s2//"three"/"three3three"}
    s4=${s3//"four"/"four4four"}
    s5=${s4//"five"/"five5five"}
    s6=${s5//"six"/"six6six"}
    s7=${s6//"seven"/"seven7seven"}
    s8=${s7//"eight"/"eight8eight"}
    s9=${s8//"nine"/"nine9nine"}
    trimmed=$(echo "$s9" | tr -cd [:digit:])
    len=$(expr length "$trimmed")
    d1=${trimmed:0:1}
    d2=${trimmed:(len-1):1}
    sum=$(($sum+"$d1""$d2"))
done < "$input"
echo "$sum"