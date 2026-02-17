@echo off
echo Eliminando archivo grande del indice de Git...
git rm --cached datos/qog/qog_std_ts_jan24.csv

echo Confirmando cambios en el commit actual...
git commit --amend -C HEAD

echo Verificando si el archivo sigue en el indice...
git ls-files datos/qog/qog_std_ts_jan24.csv

echo Si no ves el nombre del archivo arriba, todo ha ido bien.
echo Ahora intenta subir de nuevo con git push.
pause
