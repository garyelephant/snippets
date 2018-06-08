## Hadoop Metrics2 Sample Codes

This projects shows how to use hadoop-metrics2 to generate and send metrics for your own java application.

### Step 1 Add Dependencies in pom.xml

```
        <!-- https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common -->
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-common</artifactId>
            <version>2.7.1</version>
        </dependency>
```

### Step 2 Implement Custom Source

```
package com.example.metrics;

import org.apache.hadoop.metrics2.annotation.Metric;
import org.apache.hadoop.metrics2.annotation.Metrics;

@Metrics(context="MyContext")
public class MyMetrics {

    @Metric("My metric description")
    public int getMyMetric() {
        return 42;
    }
}



```

### Step 3 Implement Custom Sink Or Use Existing Sink

```
package com.example.metrics;

import org.apache.commons.configuration.SubsetConfiguration;
import org.apache.hadoop.metrics2.MetricsRecord;
import org.apache.hadoop.metrics2.MetricsSink;


public class MySink implements MetricsSink {

    public void putMetrics(MetricsRecord record) {
        System.out.println(record);
    }
    public void init(SubsetConfiguration conf) {}
    public void flush() {}
}

```

### Step 4 Config File

```
test.sink.mysink0.class=com.example.metrics.MySink

# sample period in seconds
*.period=1
```

### Step 5 Main Entry

```
package com.example.metrics;

import org.apache.hadoop.metrics2.MetricsSystem;
import org.apache.hadoop.metrics2.lib.DefaultMetricsSystem;

public class Test {

    public static void main(String[] args) throws Exception {

        MetricsSystem metricsSystem = DefaultMetricsSystem.initialize("test"); // called once per application
        metricsSystem.register(new MyMetrics());
        metricsSystem.register("sk1", "test sink1", new MySink());
        metricsSystem.start();

        Thread.currentThread().join();
    }
}

```
