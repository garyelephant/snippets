
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.StructType;

public class Test {

    public static void main(String[] args) throws Exception {
        // create nested row with nested structtype.
        Row row = RowFactory.create("a", RowFactory.create(1,2));
        StructType schema = new StructType()
                .add("f1", DataTypes.StringType)
                .add("f2", new StructType()
                    .add("f3", DataTypes.IntegerType)
                    .add("f4", DataTypes.IntegerType));
        Dataset<Row> ds = SparkSession.builder().getOrCreate().createDataFrame(Arrays.asList(row), schema);

        ds.show();
    }
 }
