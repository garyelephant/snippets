// -- use spark-shell to make your life easier !

./spark-shell

// Example 1:
val df = spark.read.json("../examples/src/main/resources/people.json")
df.createOrReplaceTempView("people")
val sqlDF = spark.sql("SELECT * FROM people")
sqlDF.show()


// Example 2:
val df1 = Seq("a").toDF


// load csv
df = spark.read.format("csv").option("header", "true").load("csvfile.csv")

// load json from local file
val df1 = spark.read.json("file:///workspace/data/slot0/acc2.txt")
df1.printSchema();
df1.registerTempTable("t1")

// load from hdfs
val df2 = spark.read.json("/user/tt/logs/livevideobyanchor_http_20180503_01")
