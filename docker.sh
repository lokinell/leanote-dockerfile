#!/bin/bash

current=`pwd`

echo $current
docker rm leanote
docker run -v $current/notedata:/root/notedata -v $current/conf:/root/leanote/conf -p 9000:9000  --name leanote leanote:1.4.2