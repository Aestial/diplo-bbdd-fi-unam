--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 1. Conectando como sys
connect sys/system2 as sysdba

prompt 2. Creando usuario c##userJava, otorgar privilegios
drop user if exists c##userJava cascade;
create user c##userJava identified by userJava quota unlimited on users;
grant create table, create session, create procedure to c##userJava;

Prompt 3. Otorgar permisos para cargar archivos asociados con los programas Java
--#TODO
begin 
  dbms_java.grant_permission(
    'C##USERJAVA','java.util.PropertyPermission','*', 'read,write');
  dbms_java.grant_permission(
    'C##USERJAVA','java.util.PropertyPermission','*','read');
  dbms_java.grant_permission(
    'C##USERJAVA','SYS:java.lang.RuntimePermission', 'getClassLoader', ' ' );
  dbms_java.grant_permission(
     'C##USERJAVA','SYS:oracle.aurora.security.JServerPermission', 'Verifier', ' ' );
  dbms_java.grant_permission(
     'C##USERJAVA','SYS:java.lang.RuntimePermission',
     'accessClassInPackage.sun.util.calendar', ' ' ) ; 
  dbms_java.grant_permission(
     'C##USERJAVA','java.net.SocketPermission', '*', 'connect,resolve' );
  dbms_java.grant_permission(
     'C##USERJAVA', 'SYS:java.lang.RuntimePermission', 'createClassLoader', ' ');
  --Permiso de lectura del archivo de entrada
  dbms_java.grant_permission(
     'C##USERJAVA','SYS:java.io.FilePermission', '/tmp/paisaje.png', 'read');
  --permiso de lectura y escritura para el archivo de salida
  dbms_java.grant_permission(
     'C##USERJAVA','SYS:java.io.FilePermission',
    '/tmp/output-paisaje.png', 'read,write,delete');  
end;
/
--TODO#
prompt Listo!