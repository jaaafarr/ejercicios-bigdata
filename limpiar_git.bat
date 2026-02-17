@echo off
echo Eliminando archivo grande del indice de Git...
git rm --cached datos/qog/qog_std_ts_jan24.csv

echo Confirmando cambios...
git commit --amend -C HEAD

echo Listo. Ahora puedes intentar subir de nuevo con git_push.bat
pause
