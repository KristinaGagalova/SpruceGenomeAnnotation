## Convert to csv format from html

Batches of GeneValiudator runs. Divide proteins in bins.     

Get the csv tabular format, list_html is the list of files with relative path.   
```
head list_names.in
#./Batch3/WS77111-v2_Maker_LoweAEDNoCont_3.fa.html/results2.html
#./Batch3/WS77111-v2_Maker_LoweAEDNoCont_3.fa.html/results1.html
#./Batch3/WS77111-v2_Maker_LoweAEDNoCont_3.fa.html/results4.html
#./Batch3/WS77111-v2_Maker_LoweAEDNoCont_3.fa.html/results3.html
#./Batch2/WS77111-v2_Maker_LoweAEDNoCont_2.fa.html/results2.html

while read line; do nam=$(basename $line | sed 's/.html/.csv/') && batch=$(echo $line | cut -d'/' -f2) && python ConvertHtlmToCsv.py ${batch}_${nam} $line; done < list_html.in
```

Get the rating type
```
while read line; do nam=$(basename $line) && batch=$(echo $line | cut -d"/" -f2) && grep "data-score=" $line | awk -F "data-score=" '{print $2}' | cut -d ">" -f1 | sed 's/"//g' > ${batch}_${nam}.rate; done < list_html.in
```

Remove odd characters
```
for file in *.csv0.csv ; do cat -v $file | sed 's/\^M//g;s/M-BM-//g;s/,$//' > ${file}1 && mv ${file}1 ${file}; done
```

Concatenate the files
list_names.in contains the prefixes to loop through (simple without for loop)
```
head list_names.in
#Batch1_results1
#Batch1_results2
#Batch1_results3
#Batch2_results

while read line; do paste -d "," <(cat ${line}.csv0.csv | grep -v "#" | sed 's/,,/,/g' | sed 's/"//g') ${line}.html.rate | sed 's/\[[^][]*\]//g' | sort -k1,1n > ${line}.out; done < list_names.in
rm *.csv0.csv *.html.rate
```
