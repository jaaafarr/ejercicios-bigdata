# 🛠️ Scripts de Automatización

Herramientas para gestión eficiente del repositorio educativo.

---

## 📜 Scripts Disponibles

### `profe.bat` / `profe.sh`

**Script maestro con menú interactivo** para gestionar todo el flujo de revisión de PRs.

**Uso:**
```bash
# Windows
.\scripts\profe.bat

# Linux/Mac
./scripts/profe.sh
```

**Funciones:**
- ✅ Revisar PRs localmente
- ✅ Aprobar y comentar PRs
- ✅ Mergear a branches de entregas
- ✅ Guardar trabajos destacados
- ✅ Crear branches de curso
- ✅ Ver estadísticas
- ✅ Sincronizar branches

---

## 📋 Requisitos

### Obligatorios
- **Git** - Control de versiones
  - Descarga: https://git-scm.com/

### Recomendados
- **GitHub CLI (`gh`)** - Automatización completa
  - Descarga: https://cli.github.com/
  - Permite aprobar/comentar PRs desde terminal
  - **100% GRATIS**

---

## 🚀 Configuración Inicial

### 1. Instalar GitHub CLI (Recomendado)

**Windows:**
```bash
winget install GitHub.cli
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install gh
```

**Mac:**
```bash
brew install gh
```

### 2. Autenticarse (Una sola vez)

```bash
gh auth login
```

Sigue las instrucciones en pantalla:
1. Selecciona GitHub.com
2. Selecciona HTTPS
3. Autentícate con tu navegador
4. ¡Listo!

---

## 💡 Uso Típico

### Revisar un PR Completo

```bash
.\scripts\profe.bat
# Opción 5: Flujo completo

# El script te guía paso a paso:
# 1. Lista PRs pendientes
# 2. Descargas el PR que elijas
# 3. Lo ejecutas localmente
# 4. Calificas y comentas
# 5. Apruebas en GitHub
# 6. Mergeas a branch de entregas
# 7. (Opcional) Guardas como destacado
# 8. Vuelves a main limpio
```

**Tiempo total:** ~3-5 minutos por PR

### Solo Revisar Localmente

```bash
.\scripts\profe.bat
# Opción 1: Revisar PR

# Descarga el PR
# Lo pruebas
# Vuelves a main cuando quieras
```

### Crear Nuevo Curso

```bash
.\scripts\profe.bat
# Opción 7: Crear branch de curso

# Nombre: 2025-02
# Crea: entregas-2025-02
# Pushea a GitHub
# Vuelve a main
```

---

## 📖 Documentación Completa

Para flujos detallados y casos de uso:
- [PARA_PROFESOR.md](../PARA_PROFESOR.md) - Guía completa de gestión

---

## 🐛 Troubleshooting

### "gh: command not found"

GitHub CLI no está instalado.

**Solución:**
- Instala desde: https://cli.github.com/
- O trabaja sin él (funcionalidad limitada)

### "Permission denied"

En Linux/Mac, dale permisos de ejecución:

```bash
chmod +x scripts/profe.sh
```

### "Not a git repository"

Debes ejecutar el script desde la raíz del repositorio:

```bash
cd ejercicios_bigdata
.\scripts\profe.bat
```

---

<p align="center">
  <strong>Automatización al servicio de la educación</strong> 🚀
</p>
