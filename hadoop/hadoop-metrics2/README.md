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

### Step 6 Run Your App

You will see the following logs in console:

```
MetricsRecordImpl{timestamp=1528439762366, name=MetricsSystem, description=MetricsSystem record, tags=[MetricsTag{info=MsInfo{name=Context, description=Metrics context}, value=metricssystem}, MetricsTag{info=MsInfo{name=Hostname, description=Local hostname}, value=gaoyingjuMacBook-Pro.local}], metrics=[MetricGaugeInt{info=MsInfo{name=NumActiveSources, description=Number of active metrics sources}, value=1}, MetricGaugeInt{info=MsInfo{name=NumAllSources, description=Number of all registered metrics sources}, value=1}, MetricGaugeInt{info=MsInfo{name=NumActiveSinks, description=Number of active metrics sinks}, value=2}, MetricGaugeInt{info=MsInfo{name=NumAllSinks, description=Number of all registered metrics sinks}, value=1}, MetricCounterLong{info=MetricsInfoImpl{name=Sink_mysink0NumOps, description=Number of ops for sink end to end latency}, value=717}, MetricGaugeDouble{info=MetricsInfoImpl{name=Sink_mysink0AvgTime, description=Average time for sink end to end latency}, value=1.0}, MetricCounterInt{info=MetricsInfoImpl{name=Sink_mysink0Dropped, description=Dropped updates per sink}, value=0}, MetricGaugeInt{info=MetricsInfoImpl{name=Sink_mysink0Qsize, description=Queue size}, value=0}, MetricCounterLong{info=MetricsInfoImpl{name=Sink_sk1NumOps, description=Number of ops for sink end to end latency}, value=717}, MetricGaugeDouble{info=MetricsInfoImpl{name=Sink_sk1AvgTime, description=Average time for sink end to end latency}, value=1.0}, MetricCounterInt{info=MetricsInfoImpl{name=Sink_sk1Dropped, description=Dropped updates per sink}, value=0}, MetricGaugeInt{info=MetricsInfoImpl{name=Sink_sk1Qsize, description=Queue size}, value=0}, MetricCounterLong{info=MetricsInfoImpl{name=SnapshotNumOps, description=Number of ops for snapshot stats}, value=1435}, MetricGaugeDouble{info=MetricsInfoImpl{name=SnapshotAvgTime, description=Average time for snapshot stats}, value=0.0}, MetricCounterLong{info=MetricsInfoImpl{name=PublishNumOps, description=Number of ops for publishing stats}, value=1434}, MetricGaugeDouble{info=MetricsInfoImpl{name=PublishAvgTime, description=Average time for publishing stats}, value=0.0}, MetricCounterLong{info=MetricsInfoImpl{name=DroppedPubAll, description=Dropped updates by all sinks}, value=0}]}
MetricsRecordImpl{timestamp=1528439763366, name=MyMetrics, description=MyMetrics, tags=[MetricsTag{info=MsInfo{name=Context, description=Metrics context}, value=MyContext}, MetricsTag{info=MsInfo{name=Hostname, description=Local hostname}, value=gaoyingjuMacBook-Pro.local}], metrics=[MetricGaugeInt{info=MetricsInfoImpl{name=MyMetric, description=My metric description}, value=42}]}
MetricsRecordImpl{timestamp=1528439763366, name=MyMetrics, description=MyMetrics, tags=[MetricsTag{info=MsInfo{name=Context, description=Metrics context}, value=MyContext}, MetricsTag{info=MsInfo{name=Hostname, description=Local hostname}, value=gaoyingjuMacBook-Pro.local}], metrics=[MetricGaugeInt{info=MetricsInfoImpl{name=MyMetric, description=My metric description}, value=42}]}
```
