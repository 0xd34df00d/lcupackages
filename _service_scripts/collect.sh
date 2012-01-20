#! /bin/sh

d="$1/dists/main/all"

for i in `/bin/ls | grep -v README | grep -v _service`; do mkdir $d/$i; cp $i/*.xml $d/$i; cp $i/arch/*.tar.gz $d/$i; done
