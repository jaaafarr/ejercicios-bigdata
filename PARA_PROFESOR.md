# 👨‍🏫 Guía Completa para el Profesor

Esta guía contiene TODO lo que necesitas para gestionar el repositorio de forma eficiente e intuitiva.

---

## 📋 Índice

1. [Filosofía del Repositorio](#1-filosofía-del-repositorio)
2. [Arquitectura de Branches](#2-arquitectura-de-branches)
3. [Script Maestro `profe`](#3-script-maestro-profe)
4. [Flujo Completo de Revisión](#4-flujo-completo-de-revisión)
5. [Gestión de Trabajos Destacados](#5-gestión-de-trabajos-destacados)
6. [Escalabilidad (Si el repo se viraliza)](#6-escalabilidad-si-el-repo-se-viraliza)
7. [Configuración Inicial](#7-configuración-inicial)
8. [Contribuciones Externas](#8-contribuciones-externas)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Filosofía del Repositorio

### 🎯 Objetivos Principales

1. **Main siempre limpio** - Listo para que cualquiera clone y use
2. **Histórico completo** - Todos los trabajos preservados en branches
3. **Destacar calidad** - Top 2-3 trabajos por curso visibles
4. **Gestión eficiente** - Automatización para no perder tiempo
5. **Escalable** - Preparado para crec

er de 10 a 1000+ alumnos

### 🏗️ Estrategia: OPCIÓN 1 HÍBRIDA

```
main (SIEMPRE LIMPIO)
├── Tu código base
├── Ejemplos-destacados/ (solo 2-3 mejores por curso)
└── Scripts de automatización

entregas-2025-01 (TODOS los trabajos del curso)
├── Todo lo de main +
└── Todos los dashboards del curso

entregas-2025-02 (siguiente curso)
└── ...
```

### 💡 Principios

- **Main es sagrado** - Solo tu código base + destacados curados
- **Branches son histórico** - Todo se preserva por curso
- **Automatización primero** - Scripts para TODO
- **Comunidad sostenible** - Sistema de 3 niveles para escalar

---

## 2. Arquitectura de Branches

### Branch: `main`

**Contenido:**
```
main/
├── datos/
├── ejercicios/
├── dashboards/
│   ├── nyc_taxi_eda/           ← Tu ejemplo base
│   └── ejemplos-destacados/     ← Solo 2-3 mejores por curso
│       ├── 2025-01-juan-dashboard/
│       ├── 2025-01-maria-ml/
│       └── README.md
└── scripts/                     ← Scripts de automatización
    ├── profe.bat
    ├── profe.sh
    └── README.md
```

**Protección:**
- ✅ Requiere PR para cambios
- ✅ Requiere aprobación
- ✅ Ni tú puedes pushear directo
- ❌ No se puede forzar push
- ❌ No se puede borrar

### Branch: `entregas-YYYY-MM`

**Ejemplo:** `entregas-2025-01`

**Contenido:**
```
entregas-2025-01/
├── [Todo lo de main] +
├── dashboards/
│   ├── nyc_taxi_eda/
│   ├── ejemplos-destacados/
│   ├── juan-perez-dashboard/    ← Trabajo de Juan
│   ├── maria-gomez-dashboard/   ← Trabajo de María
│   ├── pedro-lopez-dashboard/   ← Trabajo de Pedro
│   └── [Todos los dashboards del curso]
```

**Ciclo de vida:**
1. Se crea al inicio del curso
2. Recibe merges de PRs durante el curso
3. Se preserva indefinidamente
4. NUNCA se elimina

**Protección:**
- ❌ Sin protección (profesor puede pushear directo)
- Es una branch de acumulación

### Branch: `review-pr-XXX` (Temporales)

**Propósito:** Revisar un PR localmente sin tocar `main`

**Creación:** Automática por los scripts

**Eliminación:** Automática después de revisar

---

## 3. Script Maestro `profe`

### 3.1 ¿Qué es?

UN SOLO SCRIPT con menú interactivo que hace TODO:
- Revisar PRs
- Aprobar y comentar
- Mergear a branches de entregas
- Guardar destacados
- Ver estadísticas
- Gestionar cursos

### 3.2 Cómo Usarlo

**Windows:**
```bash
.\scripts\profe.bat
```

**Linux/Mac:**
```bash
./scripts/profe.sh
```

### 3.3 Menú Principal

```
╔════════════════════════════════════════════════════════════╗
║       🎓 GESTIÓN DE REPOSITORIO EDUCATIVO                  ║
║          Proyecto: ejercicios-bigdata                      ║
╚════════════════════════════════════════════════════════════╝

📊 ESTADO ACTUAL:
   • Branch actual: main
   • PRs pendientes: 3
   • Branch de curso activa: entregas-2025-01

┌────────────────────────────────────────────────────────────┐
│ ¿QUÉ QUIERES HACER?                                        │
└────────────────────────────────────────────────────────────┘

 1) 📥 Revisar PR (descargar y probar localmente)
 2) 🔙 Volver a main limpio
 3) ✅ Aprobar y mergear PR a entregas
 4) ⭐ Guardar PR como trabajo destacado
 5) 🎯 Flujo completo: Revisar → Aprobar → Mergear → Destacar
 6) 📊 Ver estadísticas del curso
 7) 🌱 Crear nueva branch de curso
 8) 🔄 Sincronizar entregas con main
 9) ℹ️  Ayuda y documentación
 0) 🚪 Salir

Opción [1-9, 0]:
```

### 3.4 Requisitos Previos

#### GitHub CLI (Recomendado para automatización completa)

**¿Qué es?**
- Herramienta oficial de GitHub
- 100% GRATIS
- Permite aprobar/comentar PRs desde terminal
- Autenticación OAuth (segura)

**Instalación:**

Windows:
```bash
winget install GitHub.cli
# O descarga de: https://cli.github.com/
```

Linux:
```bash
# Ubuntu/Debian
sudo apt install gh

# Fedora
sudo dnf install gh
```

Mac:
```bash
brew install gh
```

**Configuración (una sola vez):**
```bash
gh auth login
# Sigue las instrucciones en pantalla
```

**Sin GitHub CLI:**
- Los scripts funcionan igual
- Pero tendrás que aprobar/comentar PRs manualmente en GitHub.com
- Menos automatización

---

## 4. Flujo Completo de Revisión

### 4.1 Opción 5: Flujo Completo (Recomendado)

Este es el flujo MÁS EFICIENTE. Un solo comando hace todo.

**Ejecuta:**
```bash
.\scripts\profe.bat
# Opción: 5
```

**¿Qué hace?**

#### PASO 1: Listar PRs Pendientes

```
📋 PRs PENDIENTES:
   #123 - Dashboard EDA - Juan Pérez (@juanp)
   #124 - Dashboard ML - María García (@mariag)
   #125 - Dashboard Advanced - Carlos López (@carlosl)

¿Cuál PR quieres revisar? [123-125]:
```

Ingresas: `123`

#### PASO 2: Descargar y Revisar

```
─────────────────────────────────────────────────────────────
PASO 2/6: Descargando PR #123
─────────────────────────────────────────────────────────────
✅ PR descargado a rama: review-pr-123
✅ Cambiado a rama: review-pr-123

📁 Dashboard encontrado: dashboards/juan-perez-dashboard/

¿Quieres ejecutar el dashboard ahora? [s/N]:
```

Si dices `s`:
```
Ejecutando: cd dashboards/juan-perez-dashboard && python app.py
[Dashboard corriendo en http://localhost:5000]

Abre http://localhost:5000 en tu navegador para revisar.
Presiona Ctrl+C cuando termines...
```

**Tú revisas el dashboard en el navegador**

#### PASO 3: Calificación

```
─────────────────────────────────────────────────────────────
PASO 3/6: Calificación
─────────────────────────────────────────────────────────────

¿El trabajo cumple los requisitos? [s/N]: s

Calificación (0-100): 95

Comentarios para el alumno:
> Excelente trabajo! Visualizaciones muy claras.
>
```

(Presiona Enter dos veces para terminar comentario)

#### PASO 4: Decisión de Merge

```
─────────────────────────────────────────────────────────────
PASO 4/6: Decisión de merge
─────────────────────────────────────────────────────────────

¿A qué curso pertenece este trabajo?

Branches de entregas existentes:
   1) entregas-2025-01
   2) entregas-2025-02
   3) Crear nuevo curso

Opción [1-3]: 1

✅ Se mergeará a: entregas-2025-01
```

#### PASO 5: ¿Es Destacado?

```
─────────────────────────────────────────────────────────────
PASO 5/6: ¿Trabajo destacado?
─────────────────────────────────────────────────────────────

Este trabajo obtuvo 95/100.

Trabajos destacados actuales en 2025-01:
   1) maria-dashboard (98/100)
   2) carlos-advanced (96/100)

¿Guardar como trabajo destacado? (top 3 del semestre) [s/N]: s

Título para destacar: Dashboard EDA Avanzado
¿Por qué es destacado?: Visualizaciones interactivas excepcionales
```

#### PASO 6: Ejecución Automática

```
─────────────────────────────────────────────────────────────
PASO 6/6: Ejecutando acciones
─────────────────────────────────────────────────────────────

[1/5] Creando comentario en GitHub...
      ✅ Comentario publicado: "Excelente trabajo! (95/100)"

[2/5] Aprobando PR en GitHub...
      ✅ PR #123 aprobado

[3/5] Mergeando a entregas-2025-01...
      ✅ Mergeado exitosamente

[4/5] Guardando como trabajo destacado...
      ✅ Copiado a: ejemplos-destacados/2025-01-juan-dashboard/
      ✅ Creado DESTACADO.md
      ✅ Commit: "Agregar trabajo destacado: 2025-01-juan-dashboard"
      ✅ Push a main

[5/5] Volviendo a main limpio...
      ✅ Branch review-pr-123 eliminada
      ✅ De vuelta en main

╔════════════════════════════════════════════════════════════╗
║  ✅ TRABAJO COMPLETADO                                     ║
╚════════════════════════════════════════════════════════════╝

Resumen:
   • PR #123 revisado y aprobado (95/100)
   • Mergeado a entregas-2025-01
   • Guardado como trabajo destacado
   • Alumno notificado por email (GitHub)

Presiona Enter para volver al menú principal...
```

**LISTO!** En menos de 5 minutos revisaste, aprobaste, mergeaste y destacaste un trabajo.

### 4.2 Flujos Alternativos

#### Solo Revisar (Sin Aprobar)

Opción 1 del menú:
- Descarga el PR
- Te deja revisarlo
- NO aprueba ni mergea nada
- Vuelves a main cuando quieras

#### Solo Aprobar y Mergear (Ya revisaste en GitHub)

Opción 3 del menú:
- No descarga localmente
- Aprueba el PR en GitHub
- Mergea a la branch de entregas
- Listo

#### Solo Guardar Destacado (De un PR ya mergeado)

Opción 4 del menú:
- Busca un dashboard ya existente
- Lo copia a ejemplos-destacados
- Crea el DESTACADO.md
- Push a main

---

## 5. Gestión de Trabajos Destacados

### 5.1 Criterios de Selección

**Máximo:** 2-3 por curso

**Criterios:**
- Calificación ≥ 90/100
- Código excepcionalmente limpio
- Visualizaciones creativas/avanzadas
- Análisis profundo
- Diversidad de técnicas

### 5.2 Estructura de Destacados

```
dashboards/ejemplos-destacados/
├── README.md                           ← Se actualiza automáticamente
├── 2025-01-juan-dashboard/
│   ├── app.py
│   ├── templates/
│   ├── README.md
│   └── DESTACADO.md                    ← Por qué fue destacado
├── 2025-01-maria-ml/
│   └── ...
└── 2025-02-carlos-advanced/
    └── ...
```

### 5.3 Archivo DESTACADO.md (Generado Auto)

```markdown
# ¿Por qué este trabajo fue destacado?

**Alumno:** Juan Pérez
**GitHub:** @juanp
**Curso:** 2025-01
**Calificación:** 95/100
**Fecha:** Enero 2025

## Aspectos Destacados

Visualizaciones interactivas excepcionales

## Aprendizajes Clave

- Implementación de filtros dinámicos
- Uso avanzado de Chart.js
- Código muy bien documentado

## Comentario del Profesor

"Excelente trabajo! Las visualizaciones son muy claras y el análisis es profundo."

## Contacto

- GitHub: [@juanp](https://github.com/juanp)
```

### 5.4 README.md de Destacados (Auto-actualizado)

El script actualiza automáticamente `ejemplos-destacados/README.md`:

```markdown
# 🌟 Trabajos Destacados de Alumnos

## 🏆 Hall of Fame

### Enero 2025 (2025-01)

#### 1. Dashboard EDA Avanzado - Juan Pérez (95/100)
- **Destacado por:** Visualizaciones interactivas excepcionales
- **Tecnologías:** Flask, Chart.js, Pandas
- [Ver dashboard →](2025-01-juan-dashboard/)

#### 2. Análisis ML - María García (98/100)
- **Destacado por:** Implementación de clustering con PySpark
- **Tecnologías:** Flask, Plotly, PySpark, Scikit-learn
- [Ver dashboard →](2025-01-maria-ml/)

[Continúa...]
```

---

## 6. Escalabilidad (Si el repo se viraliza)

### 6.1 Sistema de 3 Niveles

Si pasas de 50+ PRs por curso, activa el modo automático.

#### Nivel 1: Auto-Checks (GitHub Actions)

**Se ejecuta automáticamente en cada PR:**

✅ Verifica que existe `dashboards/[nombre]/`
✅ Verifica que existe `README.md`
✅ Ejecuta `flake8` para lint de Python
✅ Ejecuta `app.py` para verificar que no tiene errores de sintaxis
✅ Cuenta visualizaciones en el código
✅ Verifica que no hay secrets hardcodeados

**Resultado:**
- Si PASA todo → Label `auto-approved-basic`
- Si FALLA algo → Label `needs-fixes`

#### Nivel 2: Peer Review (Opcional)

**Activas sistema de peer-review:**

- 2 alumnos revisan el trabajo de otro
- Sistema de karma/puntos
- Los que más ayudan ganan badges

**Resultado:**
- Si 2 aprobaciones → Label `peer-approved`

#### Nivel 3: Profesor (Solo Destacados)

**Tú solo revisas:**
- Trabajos con `peer-approved`
- Reduces carga de 100 PRs a ~10 PRs
- Eliges top 3 para destacados

### 6.2 Modo Automático

**Activar desde el script:**

Opción 6 del menú → Configuración → Activar modo automático

**¿Qué hace?**
- PRs con `auto-approved-basic` se mergean automáticamente a `entregas-YYYY-MM`
- Tú solo revisas trabajos con calificación manual
- Reduce tu carga de trabajo 80%

**⚠️ Cuándo activar:**
- Cuando tengas >50 PRs pendientes
- Cuando confíes en los auto-checks
- Cuando necesites escalar

---

## 7. Configuración Inicial

### 7.1 Primera Vez - Setup Completo

**Paso 1: Instalar GitHub CLI (Recomendado)**

```bash
# Windows
winget install GitHub.cli

# Autenticarse
gh auth login
```

**Paso 2: Configurar Protección de `main`**

El script puede hacerlo por ti:

```bash
.\scripts\profe.bat
# Opción: 9 (Ayuda) → Configuración → Proteger main
```

O manualmente en GitHub:
1. Repo → Settings → Branches
2. Add rule → Branch name: `main`
3. Marcar:
   - ✅ Require pull request reviews (1 approval)
   - ✅ Include administrators
   - ✅ Require conversation resolution
4. Save

**Paso 3: Crear Estructura Inicial**

Ya está creada en este commit. Incluye:
- `scripts/profe.bat` y `profe.sh`
- `dashboards/ejemplos-destacados/`
- `README.md`, `PARA_ALUMNOS.md`, `PARA_PROFESOR.md`

**Paso 4: Crear Primera Branch de Entregas**

```bash
.\scripts\profe.bat
# Opción: 7 (Crear nueva branch de curso)
# Nombre: 2025-01
```

O manualmente:
```bash
git checkout -b entregas-2025-01
git push -u origin entregas-2025-01
git checkout main
```

**LISTO!** Ya puedes recibir PRs.

### 7.2 Inicio de Cada Curso

**Antes de que empiecen los alumnos:**

1. Crea branch de entregas para el curso:
   ```bash
   git checkout -b entregas-2025-02
   git push -u origin entregas-2025-02
   git checkout main
   ```

2. Crea Issue con la tarea usando template

3. Comunica a alumnos:
   - Link al repo
   - Link al Issue de la tarea
   - Fecha de entrega
   - Link a `PARA_ALUMNOS.md`

---

## 8. Contribuciones Externas

### 8.1 Contribuciones al Código Base

Si alguien de fuera quiere mejorar ejercicios, scripts, docs:

**Flujo:**
1. Fork → Cambios → PR a `main`
2. Tú revisas igual que PR de alumno
3. Si es bueno, mergeas a `main` (afecta el código base)

**Ejemplo:**
- Nuevo ejercicio de PySpark
- Mejora en script de automatización
- Corrección de bug
- Mejora de documentación

### 8.2 Dashboards de Comunidad

Si alguien quiere compartir su dashboard:

**Opción A:** Lo tratas como alumno
- Mergea a branch de entregas actual
- Puede ser destacado si es excepcional

**Opción B:** Branch separada para comunidad
```
entregas-comunidad/
└── Dashboards de contribuidores externos
```

---

## 9. Troubleshooting

### El script no funciona

**Verifica:**
```bash
# ¿Git instalado?
git --version

# ¿GitHub CLI instalado? (opcional pero recomendado)
gh --version

# ¿Estás en la raíz del repo?
ls scripts/profe.bat  # Debe existir
```

### GitHub CLI no autentica

```bash
# Re-autenticar
gh auth logout
gh auth login
```

### No puedo pushear a main

**Correcto!** Está protegido. Debes:
1. Crear rama
2. PR a main
3. Aprobar (desde otra cuenta o desactivar protección temporalmente)

### Branch de entregas tiene conflictos con main

```bash
git checkout entregas-2025-01
git merge main
# Resuelve conflictos
git commit
git push origin entregas-2025-01
```

### Perdí un PR, no sé a qué branch fue

```bash
# Buscar en todas las branches
git log --all --grep="juan"

# Buscar en branch específica
git log entregas-2025-01 --oneline | grep juan
```

---

## 📞 Soporte

### Documentación Adicional

- [Arquitectura técnica](ARQUITECTURA.md)
- [FAQ completo](docs/FAQ.md)
- [Specs del sistema](.specs/SPEC_GESTION_REPO.md)

### Contacto

- 📧 Email: cursos@todoeconometria.com
- 💼 LinkedIn: [Juan Gutiérrez](https://www.linkedin.com/in/juangutierrezconsultor/)
- 🌐 Web: [www.todoeconometria.com](https://www.todoeconometria.com)

---

## ✅ Checklist del Profesor

### Setup Inicial (Una vez)
- [ ] GitHub CLI instalado y autenticado
- [ ] Protección de `main` configurada
- [ ] Branch de entregas creada para curso actual
- [ ] Scripts funcionando correctamente

### Por Cada Curso
- [ ] Crear branch `entregas-YYYY-MM`
- [ ] Crear Issue con tarea
- [ ] Comunicar a alumnos

### Por Cada PR
- [ ] Revisar con script `profe` opción 5
- [ ] Calificar y comentar
- [ ] Mergear a branch de entregas
- [ ] (Opcional) Guardar como destacado

### Mantenimiento
- [ ] Sincronizar branches de entregas con main periódicamente
- [ ] Actualizar README de destacados mensualmente
- [ ] Revisar estadísticas del curso

---

<p align="center">
  <strong>Sistema diseñado para eficiencia y escalabilidad</strong><br>
  <a href="README.md">← Volver al README principal</a>
</p>
