
val df = spark.read.json("../examples/src/main/resources/people.json")
df.createOrReplaceTempView("people")
val sqlDF = spark.sql("SELECT * FROM people")
sqlDF.show()
