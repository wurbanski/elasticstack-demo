#!/bin/bash
if [[ ! -f 'shakespeare.json' ]]; then
    wget https://download.elastic.co/demos/kibana/gettingstarted/shakespeare.json
fi

curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/shakespeare/_bulk?pretty' -u elastic:changeme --data-binary @shakespeare.json
