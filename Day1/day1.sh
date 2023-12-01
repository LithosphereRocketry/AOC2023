#!/bin/bash

input="input.txt"
sum=0
while IFS= read -r line
do
    trimmed=$(echo "$line" | tr -cd [:digit:])
    len=$(expr length "$trimmed")
    d1=${trimmed:0:1}
    d2=${trimmed:(len-1):1}
    sum=$(($sum+"$d1""$d2"))
done < "$input"
echo "$sum"