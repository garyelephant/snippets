// Example 1:
val df = spark.read.json("../examples/src/main/resources/people.json")
df.createOrReplaceTempView("people")
val sqlDF = spark.sql("SELECT * FROM people")
sqlDF.show()


// Example 2:
val df1 = Seq("a").toDF
