
Prompt conectando como sys
connect sys/system2 as sysdba

Prompt Crea y abre el wallet.
alter system set encryption key identified by "wallet_password";

Prompt creando un nuevo tablespace

create tablespace m05_encrypted_ts
datafile '/u01/app/oracle/oradata/JRCDIP02/m05_encrypted_ts01.dbf' size 10M
autoextend on next 64k
encryption using 'aes256'
default storage(encrypt);

Prompt otorgando cuota
alter user jorge05 quota unlimited on m05_encrypted_ts;

Prompt comprobando la configuracion de los TS 
select tablespace_name, encrypted from dba_tablespaces;
Pause  [Enter] para continuar

Prompt conectando como jorge05 para crear objetos cifrados.

connect jorge05/jorge
create table mensaje_seguro(
  id number,
  mensaje varchar2(20)
) tablespace m05_encrypted_ts;

create index mensaje_seguro_ix on mensaje_seguro(mensaje)
tablespace m05_encrypted_ts;

insert into mensaje_seguro (id, mensaje) values (1,'mensaje 1');
insert into mensaje_seguro (id, mensaje) values (2,'mensaje 2');
commit;

select * from mensaje;

Prompt creando la misma tabla en el TS user sin cifrar
create table mensaje_inseguro(
  id number,
  mensaje varchar2(20)
);

insert into mensaje_inseguro (id, mensaje) values (1,'mensaje 1');
insert into mensaje_inseguro (id, mensaje) values (2,'mensaje 2');
commit;

Prompt forzando sincronización, conectando como sys
connect sys/system2 as sysdba

alter system checkpoint;

Pause [Enter] para realizar la busqueda del texto en el TS cifrado
!strings  /u01/app/oracle/oradata/JRCDIP02/m05_encrypted_ts01.dbf | grep "mensaje"


Pause [Enter] para realizar la busqueda del texto en users.dbf
!strings  /u01/app/oracle/oradata/JRCDIP02/users01.dbf | grep "mensaje"

--reiniciar y volver a mostrar los datos.
Pause Reiniciando instancia [Enter] para continuar
shutdown immediate
startup

Prompt consultando los datos nuevamente
connect jorge05/jorge

select * from mensaje_seguro;

Pause [Enter] para continuar y corregir el problema
connect sys/system2 as sysdba 
--startup
alter system set encryption wallet open identified by "wallet_password";

Mostrando datos nuevamente
connect jorge05/jorge
select * from mensaje_seguro;

Pause [Enter] para realizar limpieza

drop table mensaje_seguro;
drop table mensaje_inseguro;

connect sys/system2 as sysdba
drop tablespace m05_encrypted_ts including contents and datafiles;

Prompt Listo!
exit 
