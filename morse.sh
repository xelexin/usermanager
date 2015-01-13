#!/bin/bash

declare -A mors
mors[a]=.-
mors[b]=-...
mors[c]=-.-.

wejscie="${1,,}"

inputlen=${#wejscie}
gora=""
dol=""
for(( i=0;i<$inputlen;i++));
do
wielkosc=${#mors[${wejscie:$i:1}]}
gora=$gora${mors[${wejscie:$i:1}]}" "
dol=$dol${wejscie:$i:1}
for(( ii=0;ii<$wielkosc;ii++));
do
dol=$dol" "
done
done
echo $gora
echo "${dol}"
