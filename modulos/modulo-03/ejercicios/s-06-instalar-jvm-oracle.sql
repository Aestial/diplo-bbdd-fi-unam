--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 1. conectando como sys en cdb$root
connect sys/system2 as sysdba
whenever sqlerror exit rollback;

prompt 2. Validando usuario del s.o.
--#TODO

--TODO#

Prompt instalando Oracle JVM

Prompt 3. Modificando parámetro _system_trig_enabled
--#TODO

--TODO#

Prompt 4. Creando directorio para bitacoras
!mkdir -p /tmp/jvm

Prompt 5. Habilitando javavm
--#TODO

--TODO#

Prompt 6. Comprobando la instalación, El status debe ser  VALID
col comp_name format a30
col status format a15
set linesize window 
--#TODO

--TODO#

Prompt 7.  Mostrando los componentes de Java en la BD
--#TODO

--TODO#
pause Analizar  resultados, [Enter] para continuar

Prompt 8. Ajustando parámetros
--#TODO

--TODO#

Pause 9. Listo! Reiniciando instancia, [enter] para continuar
shutdown immediate
startup

