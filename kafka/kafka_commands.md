
### 常用命令：

获取OFFSET:

```
./kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092  --topic mytopic --time 1525536000000
```

从某个offset开始读：

```
./kafka-simple-consumer-shell.sh --broker-list localhost:9092 --topic mytopic --partition 0 --offset 359526681 --max-messages 1000 --property print.key=true --property key.separator="-"
```


生产消息(包含key, value)

```
./kafka-console-producer.sh \
  --broker-list localhost:9092 \
  --topic my-topic \
  --property "parse.key=true" \
  --property "key.separator=:"
key1:value1
key2:value2
key3:value3
```

查看[kafka] offset storage的consumer group：

```
./kafka-consumer-groups.sh --bootstrap-server 172.17.31.231:9092,172.17.31.232:9092 --group accumulator.consumer --describe
```


从文件produce到kafka

```
kafka-console-producer.sh --broker-list localhost:9092 --topic my_topic < my_file.txt
```

---

### References:

1. http://blog.sysco.no/integration/kafka-rewind-consumers-offset/

2. https://github.com/fgeller/kt

3. http://bigdatums.net/2017/05/21/send-key-value-messages-kafka-console-producer/

