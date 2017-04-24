#!/bin/bash

set -o errexit
set -o nounset

PORT=${1:-9200}

if [[ ! -f "logs.jsonl" ]]; then
  	echo "Downloading sample data..."
	wget https://download.elastic.co/demos/kibana/gettingstarted/logs.jsonl.gz
    gunzip -q logs.jsonl.gz
fi

echo "Creating data mappings..."
curl -H 'Content-Type: application/json' -XPUT http://localhost:${PORT}/logstash-2015.05.18 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';
echo
curl -H 'Content-Type: application/json' -XPUT http://localhost:${PORT}/logstash-2015.05.19 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';
echo
curl -H 'Content-Type: application/json' -XPUT http://localhost:${PORT}/logstash-2015.05.20 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';
echo
echo "Bulk uploading data..."
curl -H 'Content-Type: application/x-ndjson' -XPOST "localhost:${PORT}/_bulk?pretty" --data-binary @logs.jsonl

echo "List of indices:"
curl "localhost:${PORT}/_cat/indices?v"
