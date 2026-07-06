# Cheatsheet · awk

Fields: `$1..$NF`, `$0` whole line, `NR` line number, `NF` field count, `FS` input separator, `OFS` output separator.

```sh
# Print fields
awk '{print $2}' file
awk '{print $NF}' file             # last field
awk '{print $(NF-1)}' file         # second-to-last
awk 'BEGIN{OFS="\t"} {print $1,$3}' file

# Field separator
awk -F, '{print $1}' file.csv
awk -F'[,;]' '...'                 # regex separator

# Filter
awk 'NR==5'                        # line 5
awk 'NR>1'                         # skip header
awk '/error/'                      # lines matching pattern
awk '!/debug/'                     # inverse
awk 'length($0) > 80'              # long lines
awk '$3 > 100'                     # numeric filter

# Aggregate
awk '{s+=$1} END {print s}'        # sum
awk '{s+=$1; n++} END {print s/n}' # average
awk 'END {print NR}'               # count lines
awk '{a[$1]++} END {for (k in a) print k, a[k]}'  # group by

# Transformation
awk 'NR>1 {print $2, $1}' f.csv    # swap first two columns, skip header
awk -v x=10 '{print $1*x}'         # pass variable in

# BEGIN / END
awk 'BEGIN{print "header"} {print} END{print "done"}'

# Multi-line records
awk 'BEGIN{RS=""} ...'             # blank line separates records

# Join two files (like SQL join on column 1)
awk 'NR==FNR{a[$1]=$2; next} $1 in a {print $0, a[$1]}' lookup.tsv data.tsv

# Print unique lines preserving order
awk '!seen[$0]++'
```

Rule: if you write more than a screen of awk, switch to a script. Under a screen, awk is faster and shorter than the bash equivalent.
