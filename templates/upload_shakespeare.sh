#!/bin/bash

set -o errexit
set -o nounset

PORT=${1-9200}

if [[ ! -f 'shakespeare.json' ]]; then
    echo "downloading sample data..."
    wget https://download.elastic.co/demos/kibana/gettingstarted/shakespeare.json
fi

echo "Create mappings..."
curl -H 'Content-Type: application/json' -XPUT http://localhost:${PORT}/shakespeare -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "string", "index" : "not_analyzed" },
    "play_name" : {"type": "string", "index" : "not_analyzed" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}
';
echo
echo "Bulk uploading data..." 
curl -H 'Content-Type: application/x-ndjson' -XPOST "localhost:${PORT}/shakespeare/_bulk?pretty" --data-binary @shakespeare.json

echo "List of indices:"
curl "localhost:${PORT}/_cat/indices?v"

