import os
import requests
import sys

# URL del dataset QoG Standard Time-Series Jan24
DATA_URL = "https://www.qogdata.pol.gu.se/data/qog_std_ts_jan24.csv"
OUTPUT_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "qog_std_ts_jan24.csv")

def descargar_archivo():
    print(f"Iniciando descarga de: {DATA_URL}")
    print(f"Destino: {OUTPUT_FILE}")
    
    try:
        response = requests.get(DATA_URL, stream=True)
        response.raise_for_status()
        
        total_size = int(response.headers.get('content-length', 0))
        block_size = 8192
        downloaded = 0
        
        with open(OUTPUT_FILE, 'wb') as f:
            for chunk in response.iter_content(chunk_size=block_size):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total_size > 0:
                        percent = downloaded * 100 / total_size
                        sys.stdout.write(f"\rDescargando... {percent:.1f}%")
                        sys.stdout.flush()
        
        print("\n✅ Descarga completada exitosamente.")
        
    except Exception as e:
        print(f"\n❌ Error al descargar: {e}")

if __name__ == "__main__":
    descargar_archivo()
