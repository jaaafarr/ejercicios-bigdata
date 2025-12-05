# Especificación: Sistema de Gestión de Repositorio Educativo

**Versión:** 1.0
**Fecha:** 2025-12-05
**Estado:** En Revisión
**Estrategia:** OPCIÓN 1 HÍBRIDA (Main limpio + Branches + Carpeta curada)

---

## 1. OBJETIVOS

### 1.1 Objetivo Principal
Mantener un repositorio educativo escalable donde:
- `main` siempre está limpio y listo para nuevos usuarios
- Se preserva todo el histórico de trabajos de alumnos
- Se destacan los mejores trabajos como ejemplos
- El profesor puede revisar, aprobar y curar contenido desde PyCharm

### 1.2 Objetivos Específicos
1. **Main limpio:** Solo código base del profesor + 2-3 ejemplos destacados por curso
2. **Histórico completo:** Todos los trabajos en branches por curso
3. **Workflow automatizado:** Scripts para facilitar revisión y gestión
4. **Protección de main:** Imposible pushear directo, solo via PR
5. **Fácil navegación:** Profesor puede cambiar entre branches en PyCharm

---

## 2. ARQUITECTURA DE BRANCHES

### 2.1 Estructura de Branches

```
main                          ← Branch principal (SIEMPRE LIMPIO)
│
├── entregas-2025-01         ← Todos los trabajos curso 2025-01
├── entregas-2025-02         ← Todos los trabajos curso 2025-02
├── entregas-2026-01         ← Todos los trabajos curso 2026-01
└── [futuras entregas]
```

### 2.2 Contenido de cada Branch

#### Branch: `main`
```
ejercicios_bigdata/
├── datos/
├── ejercicios/
├── dashboards/
│   ├── nyc_taxi_eda/                    ← Ejemplo base del profesor
│   └── ejemplos-destacados/              ← Solo 2-3 mejores por curso
│       ├── 2025-01-juan-dashboard/       ← Mejor trabajo 2025-01
│       ├── 2025-01-maria-ml/             ← Otro destacado 2025-01
│       └── README.md                     ← Explica qué son estos ejemplos
├── scripts/                              ← Scripts de automatización (NUEVO)
│   ├── revisar_pr.sh
│   ├── revisar_pr.bat
│   ├── volver_main.sh
│   ├── volver_main.bat
│   ├── mergear_a_entregas.sh
│   ├── mergear_a_entregas.bat
│   ├── guardar_destacado.sh
│   └── guardar_destacado.bat
└── [documentación]
```

#### Branch: `entregas-2025-01`
```
ejercicios_bigdata/
├── [todo lo de main] +
├── dashboards/
│   ├── nyc_taxi_eda/
│   ├── ejemplos-destacados/
│   ├── juan-perez-dashboard/             ← Trabajo de Juan
│   ├── maria-gomez-dashboard/            ← Trabajo de María
│   ├── pedro-lopez-dashboard/            ← Trabajo de Pedro
│   └── [todos los demás trabajos del curso 2025-01]
```

### 2.3 Ciclo de Vida de Branches

**Creación:**
- Se crea `entregas-YYYY-MM` al inicio de cada curso
- Se bifurca desde `main`

**Actualización:**
- Recibe merges de PRs aprobados durante el curso
- Se sincroniza con `main` periódicamente si hay updates del profesor

**Preservación:**
- NUNCA se elimina
- Queda como histórico permanente

---

## 3. ESTRUCTURA DE DIRECTORIOS

### 3.1 Carpeta `ejemplos-destacados/`

**Ubicación:** `dashboards/ejemplos-destacados/`

**Propósito:**
- Inspirar a nuevos alumnos con trabajos reales de calidad
- Mostrar diferentes enfoques y niveles de complejidad
- Mantener un balance entre cantidad y calidad

**Criterios de Selección:**
- Máximo 2-3 trabajos por curso
- Código limpio y bien documentado
- Funcionalidad destacada o enfoque creativo
- Diversidad de técnicas/librerías

**Estructura:**
```
ejemplos-destacados/
├── README.md                          ← Explica qué son y criterios
├── 2025-01-juan-dashboard/            ← Prefijo con curso
│   ├── app.py
│   ├── templates/
│   ├── README.md
│   └── DESTACADO.md                   ← Por qué fue seleccionado
├── 2025-01-maria-ml/
│   └── [misma estructura]
└── 2025-02-carlos-avanzado/
    └── [misma estructura]
```

**Archivo `DESTACADO.md`:**
```markdown
# ¿Por qué este trabajo fue destacado?

**Alumno:** Juan Pérez
**Curso:** 2025-01
**Fecha:** Enero 2025

## Aspectos Destacados
- Implementación de filtros interactivos avanzados
- Uso creativo de D3.js para visualizaciones
- Código excepcionalmente limpio y comentado
- README con análisis profundo

## Aprendizajes Clave
- [Lo que otros alumnos pueden aprender]

## Contacto
- GitHub: @juanperez
```

### 3.2 Carpeta `scripts/`

**Nueva carpeta en root:** `scripts/`

**Propósito:**
- Automatizar flujo de revisión y gestión
- Facilitar trabajo del profesor en PyCharm

**Contenido:**
| Script | Descripción | Plataforma |
|--------|-------------|------------|
| `revisar_pr.sh` | Descarga PR para revisar | Linux/Mac/Git Bash |
| `revisar_pr.bat` | Descarga PR para revisar | Windows CMD |
| `volver_main.sh` | Vuelve a main y limpia | Linux/Mac/Git Bash |
| `volver_main.bat` | Vuelve a main y limpia | Windows CMD |
| `mergear_a_entregas.sh` | Mergea trabajo a branch curso | Linux/Mac/Git Bash |
| `mergear_a_entregas.bat` | Mergea trabajo a branch curso | Windows CMD |
| `guardar_destacado.sh` | Copia trabajo a ejemplos-destacados | Linux/Mac/Git Bash |
| `guardar_destacado.bat` | Copia trabajo a ejemplos-destacados | Windows CMD |
| `README.md` | Documentación de scripts | Todas |

---

## 4. FLUJO DE TRABAJO

### 4.1 Workflow Completo del Profesor

```
┌─────────────────────────────────────────────────────────────┐
│ 1. ALUMNO CREA PR                                            │
│    - Fork → Rama → Trabajo → Push → PR a main               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. PROFESOR RECIBE NOTIFICACIÓN                              │
│    - Email de GitHub                                         │
│    - Ve PR en: github.com/TodoEconometria/.../pulls         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. REVISIÓN RÁPIDA EN GITHUB                                 │
│    - Lee descripción del PR                                  │
│    - Ve diff de archivos                                     │
│    - Decide si necesita probar localmente                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4A. SI NECESITA PROBAR → EN PYCHARM                          │
│    Terminal PyCharm:                                         │
│    > .\scripts\revisar_pr.bat 123                           │
│    [Descarga PR #123 a rama temporal]                       │
│                                                              │
│    > cd dashboards\juan-dashboard                           │
│    > python app.py                                          │
│    [Prueba el dashboard]                                    │
│                                                              │
│    [Revisa código en PyCharm]                               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. DEJA COMENTARIOS EN GITHUB                                │
│    - Comentarios en líneas específicas                       │
│    - Request changes o Approve                               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. ALUMNO HACE CORRECCIONES (si aplica)                     │
│    - Push a su rama                                          │
│    - PR se actualiza automáticamente                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 7. TRABAJO APROBADO → PROFESOR DECIDE:                      │
│                                                              │
│    OPCIÓN A: Solo cerrar PR                                  │
│    - PR queda en histórico de GitHub                        │
│    - NO se mergea a ningún lado                             │
│                                                              │
│    OPCIÓN B: Mergear a branch de entregas                   │
│    > .\scripts\mergear_a_entregas.bat review-pr-123 2025-01│
│    [Mergea a entregas-2025-01]                              │
│                                                              │
│    OPCIÓN C: Además guardarlo como destacado                │
│    > .\scripts\guardar_destacado.bat juan-dashboard 2025-01│
│    [Copia a main/ejemplos-destacados/]                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 8. VOLVER A MAIN LIMPIO                                      │
│    > .\scripts\volver_main.bat                              │
│    [Vuelve a main, borra ramas temporales]                  │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Workflow Simplificado para Casos Comunes

#### Caso 1: Solo revisar en GitHub (no ejecutar)
```
1. Ve PR en GitHub
2. Revisa código en "Files changed"
3. Aprueba o pide cambios
4. Cierra PR (o mergea a entregas desde GitHub)
```

#### Caso 2: Revisar ejecutando + Aprobar + Guardar
```
PyCharm Terminal:
> .\scripts\revisar_pr.bat 123
> cd dashboards\juan-dashboard
> python app.py
[Prueba]
[Va a GitHub y aprueba]
> .\scripts\mergear_a_entregas.bat review-pr-123 2025-01
> .\scripts\volver_main.bat
```

#### Caso 3: Revisar + Destacar
```
PyCharm Terminal:
> .\scripts\revisar_pr.bat 123
> cd dashboards\juan-dashboard
> python app.py
[Es excepcional!]
[Va a GitHub y aprueba]
> .\scripts\mergear_a_entregas.bat review-pr-123 2025-01
> .\scripts\guardar_destacado.bat dashboards\juan-dashboard 2025-01
> .\scripts\volver_main.bat
```

---

## 5. ESPECIFICACIÓN DE SCRIPTS

### 5.1 Script: `revisar_pr.bat` / `revisar_pr.sh`

**Propósito:** Descargar un PR para revisión local sin tocar `main`

**Sintaxis:**
```bash
# Windows
.\scripts\revisar_pr.bat <PR_NUMBER>

# Linux/Mac
./scripts/revisar_pr.sh <PR_NUMBER>
```

**Comportamiento:**
1. Verifica que estés en la raíz del repo
2. Ejecuta: `git fetch origin pull/<PR_NUMBER>/head:review-pr-<PR_NUMBER>`
3. Ejecuta: `git checkout review-pr-<PR_NUMBER>`
4. Muestra mensaje: "✅ PR #<PR_NUMBER> listo para revisar"
5. Lista carpetas en `dashboards/` para guiar al usuario

**Ejemplo de Uso:**
```bash
C:\...\ejercicios_bigdata> .\scripts\revisar_pr.bat 123
Descargando PR #123...
✅ PR #123 listo para revisar
📁 Dashboards encontrados:
   - dashboards/juan-dashboard/

Para probar:
   cd dashboards/juan-dashboard
   python app.py
```

**Validaciones:**
- PR_NUMBER es requerido
- PR_NUMBER es un número
- Git repo existe
- Conexión a origin funciona

---

### 5.2 Script: `volver_main.bat` / `volver_main.sh`

**Propósito:** Volver a `main` y limpiar ramas de revisión temporales

**Sintaxis:**
```bash
.\scripts\volver_main.bat
```

**Comportamiento:**
1. Ejecuta: `git checkout main`
2. Pregunta: "¿Borrar ramas de revisión (review-pr-*)? (s/n)"
3. Si sí: `git branch -D review-pr-*`
4. Muestra: "✅ De vuelta en main limpio"

**Ejemplo:**
```bash
C:\...\ejercicios_bigdata> .\scripts\volver_main.bat
Cambiando a main...
¿Borrar ramas de revisión temporales? (s/n): s
Borrando review-pr-123...
✅ De vuelta en main limpio
```

---

### 5.3 Script: `mergear_a_entregas.bat` / `mergear_a_entregas.sh`

**Propósito:** Mergear un trabajo aprobado a la branch de entregas del curso

**Sintaxis:**
```bash
.\scripts\mergear_a_entregas.bat <RAMA_REVIEW> <CURSO>

# Ejemplo:
.\scripts\mergear_a_entregas.bat review-pr-123 2025-01
```

**Comportamiento:**
1. Verifica que RAMA_REVIEW existe
2. Verifica que branch `entregas-<CURSO>` existe (si no, pregunta si crear)
3. Ejecuta: `git checkout entregas-<CURSO>`
4. Ejecuta: `git merge <RAMA_REVIEW> --no-ff -m "Mergear trabajo de PR <RAMA_REVIEW>"`
5. Ejecuta: `git push origin entregas-<CURSO>`
6. Ejecuta: `git checkout main`
7. Muestra: "✅ Trabajo mergeado a entregas-<CURSO>"

**Creación de branch si no existe:**
```
Branch entregas-2025-01 no existe.
¿Crear desde main? (s/n): s
Creando entregas-2025-01 desde main...
✅ Branch creada
```

---

### 5.4 Script: `guardar_destacado.bat` / `guardar_destacado.sh`

**Propósito:** Guardar un trabajo en `ejemplos-destacados/` en `main`

**Sintaxis:**
```bash
.\scripts\guardar_destacado.bat <PATH_DASHBOARD> <CURSO>

# Ejemplo:
.\scripts\guardar_destacado.bat dashboards\juan-dashboard 2025-01
```

**Comportamiento:**
1. Verifica que PATH_DASHBOARD existe
2. Extrae nombre del dashboard
3. Crea nombre: `<CURSO>-<nombre-dashboard>`
4. Ejecuta: `git checkout main`
5. Crea: `dashboards/ejemplos-destacados/<CURSO>-<nombre>/`
6. Copia contenido de PATH_DASHBOARD a destino
7. Crea template de `DESTACADO.md` (interactivo)
8. Ejecuta: `git add dashboards/ejemplos-destacados/<CURSO>-<nombre>/`
9. Ejecuta: `git commit -m "Agregar trabajo destacado: <CURSO>-<nombre>"`
10. Pregunta: "¿Pushear a GitHub? (s/n)"
11. Si sí: `git push origin main`

**Template DESTACADO.md (interactivo):**
```
Ingresa nombre del alumno: Juan Pérez
Ingresa usuario GitHub (opcional): juanperez
¿Por qué destacaste este trabajo?:
> Filtros interactivos excepcionales

[Crea DESTACADO.md con esa info]
```

---

## 6. PROTECCIÓN DE BRANCHES

### 6.1 Protección de `main`

**Configuración en GitHub:**
- **Require pull request reviews before merging:** ✅ (1 aprobación)
- **Dismiss stale pull request approvals:** ✅
- **Require status checks to pass:** ❌ (no hay CI/CD aún)
- **Require conversation resolution:** ✅
- **Require signed commits:** ❌ (opcional)
- **Require linear history:** ❌
- **Include administrators:** ✅ (ni el profesor puede saltarse)
- **Allow force pushes:** ❌
- **Allow deletions:** ❌

**Resultado:**
- Imposible pushear directo a `main`
- Todo cambio en `main` debe pasar por PR + aprobación

### 6.2 Protección de `entregas-*`

**Configuración:**
- Sin protección (profesor puede pushear directo)
- Son branches de acumulación, no requieren proceso riguroso

---

## 7. DOCUMENTACIÓN

### 7.1 Archivo: `INSTRUCCIONES_PROFESOR.md`

**Ubicación:** Raíz del repo

**Contenido:** (Ver implementación en siguiente paso)

**Secciones:**
1. Introducción
2. Arquitectura del Repositorio
3. Flujo de Trabajo Completo
4. Uso de Scripts de Automatización
5. Casos de Uso Comunes
6. Gestión de Branches
7. Curación de Contenido
8. Troubleshooting
9. FAQ

### 7.2 Archivo: `dashboards/ejemplos-destacados/README.md`

**Contenido:**
```markdown
# Ejemplos Destacados de Alumnos

Esta carpeta contiene los mejores trabajos de alumnos de cursos anteriores.

## Propósito
- Inspirar a nuevos alumnos
- Mostrar diferentes enfoques
- Demostrar nivel de calidad esperado

## Criterios de Selección
- Código limpio y bien documentado
- Funcionalidad destacada o enfoque creativo
- README completo con análisis
- Máximo 2-3 por curso

## Trabajos Destacados

### 2025-01

#### [Nombre Dashboard 1]
- **Alumno:** Nombre
- **GitHub:** @username
- **Destacado por:** [Razón]
- **Aprendizajes clave:** [Lista]

[Continúa para cada trabajo]
```

### 7.3 Archivo: `scripts/README.md`

**Contenido:** Documentación de cada script con ejemplos

---

## 8. ESTADO INICIAL

### 8.1 Migración desde Estado Actual

**Estado Actual:**
```
main
├── datos/
├── ejercicios/
├── dashboards/
│   └── nyc_taxi_eda/
└── [docs]
```

**Acciones Iniciales:**
1. Crear carpeta `scripts/` con scripts
2. Crear carpeta `dashboards/ejemplos-destacados/` con README
3. Crear archivo `INSTRUCCIONES_PROFESOR.md`
4. Crear archivo `.specs/SPEC_GESTION_REPO.md` (este archivo)
5. Configurar protección de `main` en GitHub
6. Commit y push a `main`
7. NO crear branches `entregas-*` todavía (se crean cuando empiecen cursos)

### 8.2 Primera Branch de Entregas

**Cuándo crear:** Al inicio del primer curso que use este sistema

**Cómo crear:**
```bash
git checkout -b entregas-2025-01
git push -u origin entregas-2025-01
git checkout main
```

---

## 9. CASOS DE USO

### 9.1 Inicio de Nuevo Curso

**Profesor:**
1. Crea branch: `git checkout -b entregas-2025-02`
2. Push: `git push -u origin entregas-2025-02`
3. Vuelve a main: `git checkout main`
4. Crea Issue en GitHub con plantilla de tarea para alumnos
5. Alumnos hacen fork de `main` (limpio)

### 9.2 Alumno Entrega Trabajo

**Alumno:**
1. Fork de `main`
2. Crea rama: `git checkout -b juan-dashboard-eda`
3. Trabaja en `dashboards/juan-dashboard/`
4. Push a su fork
5. Crea PR hacia `main` del profesor

**Profesor:**
1. Revisa en GitHub
2. (Opcional) `.\scripts\revisar_pr.bat 123` para probar
3. Deja comentarios o aprueba
4. `.\scripts\mergear_a_entregas.bat review-pr-123 2025-02`
5. (Opcional) Si es destacado: `.\scripts\guardar_destacado.bat dashboards/juan-dashboard 2025-02`
6. `.\scripts\volver_main.bat`

### 9.3 Actualizar Código Base del Profesor

**Profesor:**
1. Crea rama: `git checkout -b actualizar-ejercicio-5`
2. Hace cambios
3. Commit y push
4. Crea PR a `main`
5. Mergea (auto-aprobación si la protección lo permite, o desde otra cuenta)
6. Branches `entregas-*` pueden sincronizarse opcionalmente:
   ```bash
   git checkout entregas-2025-01
   git merge main
   git push origin entregas-2025-01
   ```

### 9.4 Contribución Externa (Open Source)

**Contribuidor:**
1. Fork de `main`
2. Mejora en código base (no dashboard personal)
3. PR a `main`

**Profesor:**
1. Revisa igual que PR de alumno
2. Si es cambio al código base (no dashboard), mergea a `main` directamente
3. Si es dashboard, le pide que especifique que es contribución externa

---

## 10. MÉTRICAS Y VALIDACIÓN

### 10.1 Métricas de Éxito

**Medibles:**
- `main` solo contiene código base + max 3 destacados por curso
- Todas las entregas están en branches `entregas-*`
- 100% de cambios a `main` pasan por PR
- Profesor puede revisar un PR en <5 minutos con scripts

**Cualitativas:**
- Nuevos alumnos no se confunden al clonar
- Histórico completo accesible
- Fácil encontrar mejores trabajos

### 10.2 Validaciones Automáticas (Futuro)

**Posibles CI/CD checks:**
- Verificar que PR no cambia código en `datos/` o `ejercicios/`
- Verificar que dashboard tiene README.md
- Verificar que dashboard no tiene datos hardcodeados
- Lint de Python (flake8, black)

---

## 11. LIMITACIONES Y FUTURAS MEJORAS

### 11.1 Limitaciones Actuales

1. **Scripts no son multiplataforma perfectos:**
   - Requiere versiones .sh y .bat separadas
   - Solución futura: Scripts en Python

2. **No hay CI/CD:**
   - No hay validación automática de PRs
   - Solución futura: GitHub Actions

3. **Gestión manual de destacados:**
   - Profesor decide manualmente
   - Solución futura: Sistema de votación o estrellas

### 11.2 Roadmap Futuro

**V2.0:**
- Scripts en Python (multiplataforma)
- GitHub Actions para validar PRs
- Template automático de DESTACADO.md

**V3.0:**
- Dashboard web para ver histórico de trabajos
- Sistema de badges/logros para alumnos
- Exportar estadísticas del curso

---

## 12. APROBACIÓN Y PRÓXIMOS PASOS

### 12.1 Checklist de Aprobación

- [ ] Profesor revisa y aprueba esta especificación
- [ ] Se refinan detalles si es necesario
- [ ] Se confirma que cubre todos los casos de uso

### 12.2 Implementación

**Orden de Implementación:**
1. Crear estructura de carpetas (`scripts/`, `ejemplos-destacados/`)
2. Implementar scripts (versión Windows primero)
3. Crear `INSTRUCCIONES_PROFESOR.md`
4. Crear READMEs de carpetas nuevas
5. Configurar protección de `main` en GitHub
6. Commit y push a `main`
7. Probar flujo completo con un PR de prueba

---

## ANEXOS

### Anexo A: Comandos Git de Referencia

```bash
# Ver todas las branches
git branch -a

# Cambiar a branch de entregas
git checkout entregas-2025-01

# Ver histórico de una branch
git log entregas-2025-01 --oneline

# Comparar main vs entregas
git diff main..entregas-2025-01

# Listar archivos en una branch sin cambiar
git ls-tree -r entregas-2025-01 --name-only
```

### Anexo B: Ejemplo de Estructura Completa

```
ejercicios_bigdata/
├── .git/
├── .gitignore
├── .specs/
│   └── SPEC_GESTION_REPO.md          ← Este archivo
├── scripts/
│   ├── revisar_pr.bat
│   ├── revisar_pr.sh
│   ├── volver_main.bat
│   ├── volver_main.sh
│   ├── mergear_a_entregas.bat
│   ├── mergear_a_entregas.sh
│   ├── guardar_destacado.bat
│   ├── guardar_destacado.sh
│   └── README.md
├── datos/
├── ejercicios/
├── dashboards/
│   ├── nyc_taxi_eda/
│   └── ejemplos-destacados/
│       ├── README.md
│       ├── 2025-01-juan-dashboard/
│       │   ├── app.py
│       │   ├── templates/
│       │   ├── README.md
│       │   └── DESTACADO.md
│       └── 2025-01-maria-ml/
│           └── ...
├── LEEME.md
├── INSTRUCCIONES_ALUMNOS.md
├── INSTRUCCIONES_PROFESOR.md         ← NUEVO
├── GUIA_ENTREGA_DASHBOARDS.md
├── ARQUITECTURA_Y_STACK.md
├── ESTRUCTURA_PROYECTO.md
├── ENTENDIENDO_GIT_Y_RAMAS.md
└── requirements.txt
```

---

**FIN DE ESPECIFICACIÓN**

**Próximo paso:** Revisión y aprobación por el profesor.
