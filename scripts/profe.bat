@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: SCRIPT MAESTRO DE GESTIÓN DE REPOSITORIO EDUCATIVO
:: Autor: TodoEconometria
:: Descripción: Automatización completa de revisión y gestión de PRs
:: ============================================================================

:: Colores (si está disponible)
set "RESET=[0m"
set "BOLD=[1m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "CYAN=[36m"
set "RED=[31m"

:: Verificar que estamos en la raíz del repo
if not exist ".git" (
    echo %RED%[ERROR]%RESET% No estás en la raíz del repositorio Git
    echo Navega a la carpeta ejercicios_bigdata y vuelve a ejecutar este script
    pause
    exit /b 1
)

:: Verificar git
git --version >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Git no está instalado o no está en el PATH
    echo Instala Git desde: https://git-scm.com/
    pause
    exit /b 1
)

:: Verificar GitHub CLI (opcional pero recomendado)
gh --version >nul 2>&1
if errorlevel 1 (
    set "GH_AVAILABLE=NO"
) else (
    set "GH_AVAILABLE=YES"
)

:MENU
cls
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║       🎓 GESTIÓN DE REPOSITORIO EDUCATIVO                  ║
echo ║          Proyecto: ejercicios-bigdata                      ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

:: Obtener branch actual
for /f "tokens=*" %%a in ('git branch --show-current') do set "CURRENT_BRANCH=%%a"

:: Contar PRs pendientes (si gh está disponible)
if "%GH_AVAILABLE%"=="YES" (
    for /f %%a in ('gh pr list --state open --json number --jq "length"') do set "PR_COUNT=%%a"
) else (
    set "PR_COUNT=?"
)

echo 📊 ESTADO ACTUAL:
echo    • Branch actual: %CYAN%%CURRENT_BRANCH%%RESET%
echo    • PRs pendientes: %CYAN%%PR_COUNT%%RESET%
if "%GH_AVAILABLE%"=="NO" (
    echo    • GitHub CLI: %RED%NO instalado%RESET% (funciones limitadas)
) else (
    echo    • GitHub CLI: %GREEN%✓ Instalado%RESET%
)
echo.

echo ┌────────────────────────────────────────────────────────────┐
echo │ ¿QUÉ QUIERES HACER?                                        │
echo └────────────────────────────────────────────────────────────┘
echo.
echo  1) 📥 Revisar PR (descargar y probar localmente)
echo  2) 🔙 Volver a main limpio
echo  3) ✅ Aprobar y mergear PR a entregas
echo  4) ⭐ Guardar PR como trabajo destacado
echo  5) 🎯 Flujo completo: Revisar → Aprobar → Mergear → Destacar
echo  6) 📊 Ver estadísticas del curso
echo  7) 🌱 Crear nueva branch de curso
echo  8) 🔄 Sincronizar entregas con main
echo  9) ℹ️  Ayuda y documentación
echo  0) 🚪 Salir
echo.

set /p "OPCION=Opción [1-9, 0]: "

if "%OPCION%"=="1" goto REVISAR_PR
if "%OPCION%"=="2" goto VOLVER_MAIN
if "%OPCION%"=="3" goto APROBAR_MERGEAR
if "%OPCION%"=="4" goto GUARDAR_DESTACADO
if "%OPCION%"=="5" goto FLUJO_COMPLETO
if "%OPCION%"=="6" goto ESTADISTICAS
if "%OPCION%"=="7" goto CREAR_BRANCH_CURSO
if "%OPCION%"=="8" goto SINCRONIZAR
if "%OPCION%"=="9" goto AYUDA
if "%OPCION%"=="0" goto SALIR

echo %RED%Opción inválida%RESET%
timeout /t 2 >nul
goto MENU

:: ============================================================================
:: OPCIÓN 1: REVISAR PR
:: ============================================================================
:REVISAR_PR
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  📥 REVISAR PR LOCALMENTE
echo ═══════════════════════════════════════════════════════════
echo.

if "%GH_AVAILABLE%"=="YES" (
    echo 📋 PRs PENDIENTES:
    echo.
    gh pr list --state open
    echo.
)

set /p "PR_NUM=Ingresa el número del PR: "

if "%PR_NUM%"=="" (
    echo %RED%Debes ingresar un número de PR%RESET%
    pause
    goto MENU
)

echo.
echo Descargando PR #%PR_NUM%...
git fetch origin pull/%PR_NUM%/head:review-pr-%PR_NUM% 2>nul

if errorlevel 1 (
    echo %RED%[ERROR]%RESET% No se pudo descargar el PR #%PR_NUM%
    echo Verifica que el número sea correcto
    pause
    goto MENU
)

git checkout review-pr-%PR_NUM%

echo %GREEN%✅ PR #%PR_NUM% descargado%RESET%
echo %GREEN%✅ Cambiado a rama: review-pr-%PR_NUM%%RESET%
echo.

:: Buscar dashboards
echo 📁 Buscando dashboards...
for /d %%d in (dashboards\*) do (
    if not "%%~nxd"=="nyc_taxi_eda" if not "%%~nxd"=="ejemplos-destacados" (
        echo    • %%~nxd
        set "DASHBOARD_FOUND=%%d"
    )
)

echo.
set /p "RUN_DASHBOARD=¿Ejecutar el dashboard ahora? [s/N]: "

if /i "%RUN_DASHBOARD%"=="s" (
    if defined DASHBOARD_FOUND (
        echo.
        echo Ejecutando dashboard...
        echo Abre http://localhost:5000 en tu navegador
        echo %YELLOW%Presiona Ctrl+C para detener el servidor%RESET%
        echo.
        cd %DASHBOARD_FOUND%
        python app.py
        cd ..\..
    ) else (
        echo %YELLOW%No se encontró dashboard para ejecutar%RESET%
    )
)

echo.
echo %CYAN%Revisión completada%RESET%
echo Para volver a main, usa la opción 2 del menú principal
pause
goto MENU

:: ============================================================================
:: OPCIÓN 2: VOLVER A MAIN
:: ============================================================================
:VOLVER_MAIN
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  🔙 VOLVER A MAIN LIMPIO
echo ═══════════════════════════════════════════════════════════
echo.

git checkout main

echo %GREEN%✅ De vuelta en main%RESET%
echo.

:: Listar branches de revisión
set "REVIEW_BRANCHES="
for /f "tokens=*" %%b in ('git branch ^| findstr "review-pr-"') do (
    set "REVIEW_BRANCHES=!REVIEW_BRANCHES! %%b"
)

if defined REVIEW_BRANCHES (
    echo Branches de revisión encontradas:%REVIEW_BRANCHES%
    echo.
    set /p "DELETE_REVIEWS=¿Eliminar branches de revisión? [s/N]: "

    if /i "!DELETE_REVIEWS!"=="s" (
        for /f "tokens=*" %%b in ('git branch ^| findstr "review-pr-"') do (
            set "BRANCH=%%b"
            set "BRANCH=!BRANCH:~2!"
            git branch -D !BRANCH! >nul 2>&1
            echo %GREEN%✅ Eliminada: !BRANCH!%RESET%
        )
    )
)

echo.
pause
goto MENU

:: ============================================================================
:: OPCIÓN 3: APROBAR Y MERGEAR
:: ============================================================================
:APROBAR_MERGEAR
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  ✅ APROBAR Y MERGEAR PR
echo ═══════════════════════════════════════════════════════════
echo.

if "%GH_AVAILABLE%"=="NO" (
    echo %YELLOW%[AVISO]%RESET% GitHub CLI no está disponible
    echo Esta función requiere GitHub CLI para aprobar PRs automáticamente
    echo.
    echo Opciones:
    echo  1. Instala GitHub CLI: https://cli.github.com/
    echo  2. Aprueba el PR manualmente en GitHub.com y luego mergea aquí
    echo.
    pause
    goto MENU
)

if "%GH_AVAILABLE%"=="YES" (
    echo 📋 PRs PENDIENTES:
    echo.
    gh pr list --state open
    echo.
)

set /p "PR_NUM=Número del PR a aprobar: "
set /p "CALIFICACION=Calificación (0-100): "
set /p "COMENTARIO=Comentario para el alumno: "

echo.
echo Aprobando PR #%PR_NUM%...

gh pr review %PR_NUM% --approve --body "Calificación: %CALIFICACION%/100. %COMENTARIO%"

if errorlevel 1 (
    echo %RED%[ERROR]%RESET% No se pudo aprobar el PR
    pause
    goto MENU
)

echo %GREEN%✅ PR aprobado%RESET%
echo.

:: Listar branches de entregas
echo Branches de entregas disponibles:
set "COUNTER=0"
for /f "tokens=*" %%b in ('git branch -r ^| findstr "origin/entregas-"') do (
    set /a COUNTER+=1
    set "BRANCH_!COUNTER!=%%b"
    set "BRANCH_NAME=%%b"
    set "BRANCH_NAME=!BRANCH_NAME:origin/=!"
    echo  !COUNTER!) !BRANCH_NAME!
)

if %COUNTER%==0 (
    echo %YELLOW%No hay branches de entregas%RESET%
    echo Crea una con la opción 7 del menú
    pause
    goto MENU
)

echo  %COUNTER:~0,1%+1) Crear nueva branch
echo.

set /p "BRANCH_CHOICE=Selecciona branch [1-%COUNTER%]: "

if "%BRANCH_CHOICE%"=="" goto MENU

:: TODO: Implementar merge a branch de entregas
echo.
echo %YELLOW%[TODO]%RESET% Función de merge en desarrollo
echo Por ahora, mergea manualmente el PR en GitHub
pause
goto MENU

:: ============================================================================
:: OPCIÓN 5: FLUJO COMPLETO
:: ============================================================================
:FLUJO_COMPLETO
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  🎯 FLUJO COMPLETO DE REVISIÓN
echo ═══════════════════════════════════════════════════════════
echo.
echo Este flujo te guiará paso a paso:
echo  1. Descargar PR
echo  2. Revisar localmente
echo  3. Calificar
echo  4. Aprobar
echo  5. Mergear a entregas
echo  6. (Opcional) Guardar como destacado
echo.

pause

:: TODO: Implementar flujo completo interactivo
echo.
echo %YELLOW%[TODO]%RESET% Flujo completo en desarrollo
echo.
echo Por ahora, usa las opciones individuales:
echo  - Opción 1: Revisar PR
echo  - Opción 3: Aprobar y mergear
echo  - Opción 4: Guardar destacado
echo.

pause
goto MENU

:: ============================================================================
:: OPCIÓN 6: ESTADÍSTICAS
:: ============================================================================
:ESTADISTICAS
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  📊 ESTADÍSTICAS DEL CURSO
echo ═══════════════════════════════════════════════════════════
echo.

if "%GH_AVAILABLE%"=="YES" (
    echo PRs por estado:
    echo.
    for /f %%a in ('gh pr list --state open --json number --jq "length"') do echo  • Abiertos: %%a
    for /f %%a in ('gh pr list --state closed --json number --jq "length"') do echo  • Cerrados: %%a
    for /f %%a in ('gh pr list --state merged --json number --jq "length"') do echo  • Mergeados: %%a
    echo.
) else (
    echo %YELLOW%GitHub CLI no disponible - Estadísticas limitadas%RESET%
    echo.
)

echo Branches de entregas:
git branch -r | findstr "origin/entregas-"
echo.

echo Trabajos destacados:
if exist "dashboards\ejemplos-destacados" (
    dir /b /ad dashboards\ejemplos-destacados | findstr /v "README"
) else (
    echo  (Ninguno aún)
)
echo.

pause
goto MENU

:: ============================================================================
:: OPCIÓN 7: CREAR BRANCH DE CURSO
:: ============================================================================
:CREAR_BRANCH_CURSO
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  🌱 CREAR NUEVA BRANCH DE CURSO
echo ═══════════════════════════════════════════════════════════
echo.

echo Formato recomendado: YYYY-MM
echo Ejemplo: 2025-01, 2025-02, 2026-01
echo.

set /p "CURSO=Nombre del curso: "

if "%CURSO%"=="" (
    echo %RED%Debes ingresar un nombre%RESET%
    pause
    goto MENU
)

set "BRANCH_NAME=entregas-%CURSO%"

echo.
echo Creando branch: %BRANCH_NAME%...

git checkout -b %BRANCH_NAME%

if errorlevel 1 (
    echo %RED%[ERROR]%RESET% No se pudo crear la branch
    pause
    goto MENU
)

git push -u origin %BRANCH_NAME%

if errorlevel 1 (
    echo %RED%[ERROR]%RESET% No se pudo pushear la branch
    pause
    goto MENU
)

echo %GREEN%✅ Branch creada: %BRANCH_NAME%%RESET%
echo %GREEN%✅ Pusheada a origin%RESET%
echo.

git checkout main
echo %GREEN%✅ De vuelta en main%RESET%
echo.

pause
goto MENU

:: ============================================================================
:: OPCIÓN 8: SINCRONIZAR
:: ============================================================================
:SINCRONIZAR
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  🔄 SINCRONIZAR ENTREGAS CON MAIN
echo ═══════════════════════════════════════════════════════════
echo.

echo Branches de entregas:
git branch -r | findstr "origin/entregas-"
echo.

set /p "SYNC_BRANCH=Branch a sincronizar (ej: entregas-2025-01): "

if "%SYNC_BRANCH%"=="" goto MENU

echo.
echo Sincronizando %SYNC_BRANCH% con main...

git checkout %SYNC_BRANCH%
git merge main

if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Hay conflictos. Resuélvelos manualmente.
    echo Luego ejecuta: git commit ^&^& git push
    pause
    goto MENU
)

git push origin %SYNC_BRANCH%

echo %GREEN%✅ Sincronización completada%RESET%

git checkout main
echo.

pause
goto MENU

:: ============================================================================
:: OPCIÓN 9: AYUDA
:: ============================================================================
:AYUDA
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  ℹ️  AYUDA Y DOCUMENTACIÓN
echo ═══════════════════════════════════════════════════════════
echo.
echo 📚 Documentación disponible:
echo.
echo  • PARA_PROFESOR.md - Guía completa para gestión
echo  • PARA_ALUMNOS.md - Guía para estudiantes
echo  • README.md - Descripción del proyecto
echo  • .specs\SPEC_GESTION_REPO.md - Especificación técnica
echo.
echo 🔧 Requisitos:
echo.
echo  • Git (Requerido) - https://git-scm.com/
echo  • GitHub CLI (Recomendado) - https://cli.github.com/
echo  • Python + pip (Para ejecutar dashboards)
echo.
echo 💡 Comandos útiles:
echo.
echo  • Ver branches: git branch -a
echo  • Ver PRs: gh pr list
echo  • Aprobar PR: gh pr review [NUM] --approve
echo  • Mergear PR: gh pr merge [NUM]
echo.
echo 📞 Soporte:
echo.
echo  • Email: cursos@todoeconometria.com
echo  • Web: www.todoeconometria.com
echo.

pause
goto MENU

:: ============================================================================
:: OPCIÓN 0: SALIR
:: ============================================================================
:SALIR
cls
echo.
echo Saliendo...
echo.
timeout /t 1 >nul
exit /b 0

:: ============================================================================
:: OPCIÓN 4: GUARDAR DESTACADO (Implementación básica)
:: ============================================================================
:GUARDAR_DESTACADO
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo  ⭐ GUARDAR TRABAJO COMO DESTACADO
echo ═══════════════════════════════════════════════════════════
echo.
echo %YELLOW%[TODO]%RESET% Función en desarrollo
echo.
echo Por ahora, copia manualmente:
echo  1. cd dashboards
echo  2. xcopy /E /I nombre-dashboard ejemplos-destacados\YYYY-MM-nombre-dashboard
echo  3. Crea DESTACADO.md en la carpeta
echo  4. git add, commit y push a main
echo.

pause
goto MENU
