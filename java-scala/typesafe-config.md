# Typesafe Config

## Project Introduction

A simple, easy-to-use java/scala configuartion library

project home:
https://github.com/typesafehub/config

API docs:
http://typesafehub.github.io/config/latest/api/


## Install Dependency

maven, sbt : "com.typesafe" % "config" % "1.3.1"


## Code Example

```
import com.typesafe.Config.ConfigFactory
import com.typesafe.Config.Config

Config config = ConfigFactory.load()
config.getConfig("data_source")
Config c = config.getConfig("data_source.kafka")
c.getInt("thread_num")
c.getString("kafka_broker")
c.getStringList("work_dir")
```

## Specify Config Path

```
java .... -Dconfig.file=/etc/cloud_analysis/my.conf
```

## Config example

my.conf

```
merger {
    worker {
        work_dir = [
            "/data/slot0/cloud_analysis/merger/work_dir",
            "/data/slot1/cloud_analysis/merger/work_dir",
            "/data/slot2/cloud_analysis/merger/work_dir",
            "/data/slot3/cloud_analysis/merger/work_dir",
            "/data/slot4/cloud_analysis/merger/work_dir",
            "/data/slot5/cloud_analysis/merger/work_dir",
            "/data/slot6/cloud_analysis/merger/work_dir",
            "/data/slot7/cloud_analysis/merger/work_dir",
            "/data/slot8/cloud_analysis/merger/work_dir",
            "/data/slot9/cloud_analysis/merger/work_dir"
        ]

        thread_pool.size = 24
        scheduler_url = "http://localhost:14000"
        task.retry_num = 2
    }

    scheduler {
        http.port = 14000
        # hdfs://... prefix is not needed.
        hdfs.path_prefix = "/cloud_analysis/cdnlog_v2/cdnlog"
        task {
        }
    }
}
```


