#!/bin/bash

declare -A mors
mors[a]=.-
mors[b]=-...
mors[c]=-.-.
mors[d]=-..
mors[e]=.
mors[f]=..-.
mors[g]=--.
mors[h]=....
mors[i]=..
mors[j]=.---
mors[k]=-.-
mors[l]=.-..
mors[m]=--
mors[n]=-.
mors[o]=---
mors[p]=.--.
mors[q]=--.-
mors[r]=.-.
mors[s]=...
mors[t]=-
mors[u]=..-
mors[v]=...-
mors[w]=.--
mors[x]=-..-
mors[y]=-.--
mors[z]=--..

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
wielkosclinii=`tput cols`
temp=0
warstopu=$(($((${#gora}/$wielkosclinii))+1))
for(( i=0;i<$warstopu;i++ ));
do
	startarg=$(($i * `tput cols`))
	echo "${gora:$startarg:`tput cols`}"
	echo "${dol:$startarg:`tput cols`}"
done
