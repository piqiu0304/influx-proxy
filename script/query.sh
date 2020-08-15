#!/bin/bash

echo "query test:"

curl -X POST 'http://127.0.0.1:7076/query' --data-urlencode 'q=CREATE DATABASE test'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show databases'

curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from cpu1;'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from cpu2'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from mem;'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from svr'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from "measurement with spaces, commas and \"quotes\""'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from "\"measurement with spaces, commas and \"quotes\"\""'

curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show tag keys from cpu1'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show FIELD keys from cpu2'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show TAG keys on test from mem'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show field KEYS on test from svr'

curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show MEASUREMENTS'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show series'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show series from cpu1'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show field KEYS'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show field KEYS from cpu1'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show TAG keys'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show TAG keys from cpu2'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show tag VALUES WITH key = "region"'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show tag VALUES from cpu2 WITH key = "region"'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=SHOW retention policies'
# curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show stats;'

curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show MEASUREMENTS on test'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show series on test'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show series on test from svr'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show field KEYS on test'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show field KEYS on test from svr'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show TAG keys on test'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show TAG keys on test from mem'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show tag VALUES on test WITH key = "region"'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show tag VALUES on test from mem WITH key = "region"'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=SHOW retention policies on test'
# curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show stats'


echo ""
echo "error test:"

curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q='
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * measurement'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show TAG from mem'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show TAG keys from '
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show field KEYS fr'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=show measurement'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=SHOW retention policies on newdb'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show TAG keys test from mem'
curl -G 'http://127.0.0.1:7076/query' --data-urlencode 'q=show series from cpu1'


echo ""
echo "gzip test:"

queries=(
    'q=select * from "cpu1"'
    'q=show TAG keys from mem'
    'q=show field KEYS from svr'
    'q=show MEASUREMENTS'
    'q=show series'
    'q=show field KEYS'
    'q=show TAG keys'
    'q=show tag VALUES WITH key = "region"'
    'q=SHOW retention policies'
    # 'q=show stats'
)

len=${#queries[*]}
i=0
while (($i<$len)); do
    query=${queries[$i]}
    curl -G -s 'http://127.0.0.1:7076/query?db=test&epoch=s' -H "Accept-Encoding: gzip" --data-urlencode "$query" | gzip -d
    i=$(($i+1))
done


echo ""
echo "drop test:"

curl -X POST 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=delete from cpu1'
curl -X POST 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=drop series from cpu2'
curl -X POST 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=drop measurement mem'
curl -X POST 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=drop series from svr'
curl -X POST 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=delete from "measurement with spaces, commas and \"quotes\""'
curl -X POST 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=drop measurement "\"measurement with spaces, commas and \"quotes\"\""'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from cpu1;'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from cpu2'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from mem;'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from svr'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from "measurement with spaces, commas and \"quotes\""'
curl -G 'http://127.0.0.1:7076/query?db=test' --data-urlencode 'q=select * from "\"measurement with spaces, commas and \"quotes\"\""'
