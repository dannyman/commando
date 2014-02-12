#!/bin/sh
# inventory.sh assembles a JSON string representing contents of
# mapreduce-workers.inv and spark-workers.inv for use by ansible.
i=''
i=$i'{'
i=$i'"mapreduce-workers" : '
i=$i'{"hosts" : [ '
for host in `cat mapreduce-workers.inv`; do
    i=$i"\"$host\" "
done
i=$i'] },'
i=$i'"spark-workers" : '
i=$i'{"hosts" : [ '
for host in `cat spark-workers.inv`; do
    i=$i"\"$host\" "
done
i=$i'] }'
i=$i'}'
echo $i | perl -pe 's/" "/", "/g'
#echo '{"all" : {"hosts" : [ "198.61.177.27", "198.61.176.206" ] }}'
