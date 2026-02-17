import os
import urllib.request
import sys

# Configuración
DATA_URL = "https://www.qogdata.pol.gu.se/data/qog_std_ts_jan24.csv"
# La ruta se construye relativa a este script (en 'plantilla')
# Queremos guardar en: ../data/qog/
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
TARGET_DIR = os.path.join(BASE_DIR, "../..", "data", "qog")
TARGET_FILE = os.path.join(TARGET_DIR, "qog_std_ts_jan24.csv")

def download_file():
    # 1. Crear directorios si no existen
    if not os.path.exists(TARGET_DIR):
        print(f"📂 Creando directorio: {TARGET_DIR}")
        os.makedirs(TARGET_DIR)
    else:
        print(f"📂 Directorio ya existe: {TARGET_DIR}")

    # 2. Verificar si el archivo ya existe
    if os.path.exists(TARGET_FILE):
        print(f"⚠️ El archivo ya existe en: {TARGET_FILE}")
        respuesta = input("¿Deseas sobrescribirlo? (s/n): ").lower()
        if respuesta != 's':
            print("Cancelado.")
            return

    # 3. Descargar archivo
    print(f"⬇️ Iniciando descarga desde: {DATA_URL}")
    print("Esto puede tardar unos minutos dependiendo de tu conexión...")
    
    try:
        def progress_hook(count, block_size, total_size):
            percent = int(count * block_size * 100 / total_size)
            sys.stdout.write(f"\r⏳ Descargando... {percent}%")
            sys.stdout.flush()

        urllib.request.urlretrieve(DATA_URL, TARGET_FILE, reporthook=progress_hook)
        print(f"\n✅ ¡Descarga completada con éxito!")
        print(f"📍 Archivo guardado en: {TARGET_FILE}")
        
    except Exception as e:
        print(f"\n❌ Error durante la descarga: {e}")

if __name__ == "__main__":
    download_file()
