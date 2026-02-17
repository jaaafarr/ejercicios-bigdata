import os
import sys

# Configuración para que Spark funcione bien en Windows
os.environ['PYSPARK_SUBMIT_ARGS'] = '--driver-java-options "-Djava.security.manager=allow" pyspark-shell'
os.environ['PYSPARK_PYTHON'] = sys.executable
os.environ['PYSPARK_DRIVER_PYTHON'] = sys.executable

from pyspark.sql import SparkSession, Window
import pyspark.sql.functions as F
import matplotlib.pyplot as plt

# 1. Iniciar sesión de Spark
spark = SparkSession.builder \
    .appName("TrabajoFinal_Jaafar") \
    .master("local[*]") \
    .getOrCreate()

# 2. Cargar el dataset
# Construimos la ruta absoluta al archivo CSV para evitar errores de "File not found"
base_dir = os.path.dirname(os.path.abspath(__file__))
# Subimos dos niveles (../../) para llegar a la raíz del proyecto y luego a datos/qog
csv_path = os.path.join(base_dir, "../..", "data", "qog", "qog_std_ts_jan24.csv")
# Normalizamos la ruta para que funcione bien en Windows
csv_path = os.path.normpath(csv_path)

print(f"Buscando archivo en: {csv_path}")

if not os.path.exists(csv_path):
    print("❌ Error: El archivo CSV no existe. Por favor ejecuta primero el script de descarga.")
    print("Ruta esperada:", csv_path)
    sys.exit(1)

df = spark.read.csv(csv_path, header=True, inferSchema=True)

# --- CONFIGURACIÓN DEL ANÁLISIS ---
# IMPORTANTE: Cambia estos parámetros para tu análisis
paises_a_analizar = ["ARG", "BRA", "CHL", "URY", "PRY", "VEN"]
variable_de_interes = "vdem_jpresscp"  # Variable para el modelo de efectos fijos (ej. libertad de prensa)
nombre_base_output = "revision_final_jaafar" # Nombre para los archivos de salida (.csv y .png)
# ----------------------------------

# 3. Filtrar los países
df_filtrado = df.filter(F.col("ccodealp").isin(paises_a_analizar))

# 4. DEFINIR EL MODELO DE EFECTOS FIJOS (FE)
# Creamos una ventana por país para calcular el promedio individual
windowSpec = Window.partitionBy("ccodealp")

# Calculamos la desviación (Demeaning): Valor Actual - Promedio del País
# Asegúrate de que la columna existe y no tiene nulos antes de operar
df_fe = df_filtrado.withColumn("avg_val", F.avg(variable_de_interes).over(windowSpec)) \
    .withColumn("fe_deviation", F.col(variable_de_interes) - F.col("avg_val"))

# 5. EXPORTAR DATOS A CSV
output_csv = f"{nombre_base_output}.csv"
print(f"Extrayendo datos a CSV a: {output_csv}")
try:
    df_fe.toPandas().to_csv(output_csv, index=False)
    print(f"✅ Datos exportados a {output_csv}")
except Exception as e:
    print(f"⚠️ Error al exportar CSV: {e}")

# 6. GENERAR EL GRÁFICO DE LÍNEAS PARALELAS
print("Generando gráfico de Efectos Fijos...")
pdf = df_fe.toPandas()

if pdf.empty:
    print("⚠️ El DataFrame está vacío. Verifica tus filtros de países.")
else:
    plt.figure(figsize=(10, 6))

    for pais in paises_a_analizar:
        data_pais = pdf[pdf['ccodealp'] == pais]
        if not data_pais.empty:
            # Dibujamos la línea de tendencia para cada país
            plt.plot(data_pais['year'], data_pais['fe_deviation'], label=f"País {pais}", marker='o', linestyle='-')

    plt.title(f"Modelo de Efectos Fijos: Variación Interna para '{variable_de_interes}'")
    plt.xlabel("Año")
    plt.ylabel("Desviación (Efecto Fijo)")
    plt.legend(title="País")
    plt.grid(True, alpha=0.3)

    # Guardar el gráfico
    output_png = f"{nombre_base_output}.png"
    plt.savefig(output_png)
    print(f"✅ Gráfico guardado como {output_png}")

spark.stop()
