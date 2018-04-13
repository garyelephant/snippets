#!/bin/bash

if [ -z "$1" ]
  then
    echo "Missing first argument, zookeeper host port like: my-zookeeper-hostname:2181"
    echo "Usage Example:  ./topic-last-messages.sh my-zookeeper-hostname:2181 MY_TOPIC_NAME 10 America/Chicago"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "Missing second argument, topic name like: MY_TOPIC_NAME"
    echo "Usage Example:  ./topic-last-messages.sh my-zookeeper-hostname:2181 MY_TOPIC_NAME 10 America/Chicago"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "Missing third argument, number of messages to consume from each partition, like: 10"
    echo "Usage Example:  ./topic-last-messages.sh my-zookeeper-hostname:2181 MY_TOPIC_NAME 10 America/Chicago"
    exit 1
fi

ZK=$1
TOPIC=$2
READ_LAST_COUNT=$3
TZ=$4


function get_broker_list () {
  ZK="$1"
  GET_BROKER_METADATA_COMMANDS=$(zookeeper-shell.sh "$ZK" <<< "ls /brokers/ids" | grep '^\[' | jq -r .[] | sed 's/\([0-9][0-9]*\)/ get \/brokers\/ids\/\1 /g')

  BROKER_LIST=''

  while read -r GET_BROKER_METADATA_COMMAND; do
    BROKER_JSON=$(zookeeper-shell "$ZK" <<< "$GET_BROKER_METADATA_COMMAND" 2>/dev/null | grep '"host":' )
    BROKER_HOST=$(echo "$BROKER_JSON" | jq -r .host)
    BROKER_PORT=$(echo "$BROKER_JSON" | jq -r .port)
    BROKER_LIST="$BROKER_LIST$BROKER_HOST:$BROKER_PORT,"
  done <<< "$GET_BROKER_METADATA_COMMANDS"

  echo "$BROKER_LIST" | sed 's/,$//g'
}

BROKER_LIST=$(get_broker_list "$ZK")

# todo:debug
BROKER_LIST=localhost:9092

ONE_BROKER=$(echo "$BROKER_LIST" | tr ',' '\n' | tail -n 1)

PARTITION_OFFSET_START_LIST=$(kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list "$BROKER_LIST" --time -2 --topic "$TOPIC" | sort)

PARTITION_OFFSET_END_LIST=$(kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list "$BROKER_LIST" --time -1 --topic "$TOPIC" | sort)

PARTITION_COUNT=$(echo "$PARTITION_OFFSET_START_LIST" | wc -l)

for LINE_NUMBER in `seq 1 $PARTITION_COUNT`;
do
  OFFSET_START=$(echo "$PARTITION_OFFSET_START_LIST" | head -n $LINE_NUMBER | tail -n -1 | sed 's/\([^:][^:]*\):\([0-9]*\):\([0-9]*\)/\3/g')
  OFFSET_END=$(echo "$PARTITION_OFFSET_END_LIST" | head -n $LINE_NUMBER | tail -n -1 | sed 's/\([^:][^:]*\):\([0-9]*\):\([0-9]*\)/\3/g')
  PARTITION_ID=$(expr $LINE_NUMBER - 1)
  MAX_MESSAGES=$(expr $OFFSET_END - $OFFSET_START)
  if [ "$MAX_MESSAGES" -gt "$READ_LAST_COUNT" ]; then
    MAX_MESSAGES="$READ_LAST_COUNT"
    OFFSET_START=$(expr $OFFSET_END - $MAX_MESSAGES)
  fi

  echo "$TOPIC partition $PARTITION_ID last $MAX_MESSAGES messages:"

  MESSAGES_WITH_TIMESTAMPS=$(kafka-console-consumer.sh --property print.timestamp=true --property value.deserializer=org.apache.kafka.common.serialization.BytesDeserializer --bootstrap-server "$ONE_BROKER" --topic "$TOPIC" --offset $OFFSET_START --max-messages $MAX_MESSAGES --partition $PARTITION_ID )

  LINE_COUNT=$(echo "$MESSAGES_WITH_TIMESTAMPS" | wc -l)

  for LINE_NUMBER in `seq 1 $LINE_COUNT`;
  do
    LINE=$(echo "$MESSAGES_WITH_TIMESTAMPS" | head -n $LINE_NUMBER | tail -n -1)

    TIMESTAMP=$(echo "$LINE" | sed -ne 's/CreateTime:\([0-9]*\)\t.*/\1/p')
    BYTES=$(echo "$LINE" | sed -ne 's/CreateTime:[0-9]*\t\(.*\)/\1/p' | sed 's/\\x[A-F0-9]\{2\}/ /g')
    if [ ! -z  "$TIMESTAMP" ]; then
      DATETIME_READABLE=$(TZ="$TZ" date -d@"$(expr $TIMESTAMP / 1000)")
      echo "$DATETIME_READABLE $BYTES"
    else
      echo "$LINE"
    fi
  done
done
