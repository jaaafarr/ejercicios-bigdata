from pyspark.sql import SparkSession, Window
import pyspark.sql.functions as F

# 1. Start Spark
spark = SparkSession.builder.appName("FinalProjectJaafar").getOrCreate()

# 2. Read the data
# Khas l-mlaf ikoun f l-nefs l-makan
df = spark.read.csv("qog_std_ts_jan24.csv", header=True, inferSchema=True)

# 3. Create df_fe (Fixed Effects Calculation)
# Hna fayn kankhal9o l-variable li kan fih l-mochkil
windowSpec = Window.partitionBy("ccodealp")
df_fe = df.withColumn("avg_val", F.avg("wdi_gdpcapny").over(windowSpec)) \
          .withColumn("fe_deviation", F.col("wdi_gdpcapny") - F.col("avg_val"))

# 4. Save to CSV
# Daba df_fe m3rraf (defined), maykonch khata'
output_csv = "revision_final_jaafar.csv"
print("Saving data...")
df_fe.toPandas().to_csv(output_csv, index=False)
print("Done!")
print("Done!")