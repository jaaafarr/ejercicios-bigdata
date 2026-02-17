import shutil
import os

# Rutas relativas desde la raíz del proyecto
source = os.path.join("entregas", "trabajo_final_Bousaid_Jaafar")
destination = os.path.join("entregas", "Bousaid_Jaafar")

print(f"Intentando mover: {source} -> {destination}")

if not os.path.exists(source):
    print(f"❌ Error: La carpeta origen '{source}' no existe.")
    exit(1)

if os.path.exists(destination):
    print(f"⚠️ La carpeta destino '{destination}' ya existe.")
    print("Por favor, elimínala o muévela antes de ejecutar este script.")
    exit(1)

try:
    shutil.move(source, destination)
    print("✅ ¡Movimiento completado con éxito!")
    print(f"Ahora tu proyecto está en: {destination}")
except Exception as e:
    print(f"❌ Error al mover los archivos: {e}")
