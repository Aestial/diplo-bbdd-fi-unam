--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:
whenever sqlerror exit rollback

Prompt 1. Creando spool del ejercicio en /tmp
spool /tmp/e-08b-configura-tde-oracle.txt

Prompt 2. conectando como sys en cdb$root
connect sys/system2 as sysdba

Prompt 3. Validando usuario a nivel sistema operativo
--#TODO
begin
  if sys_context('USERENV','OS_USER') != 'oracle' then
    raise_application_error(-20001,
     'El script debe ser ejecutado con el usuario oracle del s.o.');
  end if;
end;
/
--TODO#

Prompt 4. Configurando el parámetro WALLET_ROOT
--#TODO
alter system set WALLET_ROOT = '/etc/oracle/keystores/free' scope = spfile;
--TODO#

Prompt 5. Reiniciando instancia para actualizar cambios
shutdown abort
startup

Prompt 6.  Configurando el parámetro TDE_CONFIGURATION
--#TODO
alter system set TDE_CONFIGURATION = "KEYSTORE_CONFIGURATION=FILE" scope = both;
--TODO#

--Inicializar temporalmente este parámetro no documentado en caso de que se requiera
-- regenerar la TDE Wallet por alguna razón, por ejemplo, si se pierden los archivos del wallet.
--Este parámetro permite descartar la master key anterior y crear una nueva.
--No deberían existir objetos cifrados al ejecutar esta instrucción.
-- Fuente: https://dba.stackexchange.com/questions/256485/oracle-19c-cannot-create-master-key
-- NOTA: Esta solución no garantiza que se pueda reconfigurar TDE. Si el proceso falla, ¡Se
-- deberá eliminar la CDB y crear una nueva!
--alter system set "_db_discard_lost_masterkey"=true scope=memory;

Prompt 7. Conectando como syskm (empleando autenticación de s.o)
connect / as syskm

Prompt 8. Creando una TDE wallet local tipo auto-open
--Crea el wallet
--#TODO
administer key management 
  create keystore identified by walletDiplo1;
--TODO#

--Agrega propiedad local tipo auto-open
--#TODO
administer key management 
  create local auto_login keystore 
  from keystore identified by walletDiplo1;
--TODO#

Prompt 9. Agregar el password del wallet como secret
--#TODO
administer key management 
 add secret 'walletDiplo1' 
 for client 'TDE_WALLET' 
 to local auto_login keystore '/etc/oracle/keystores/free/tde_seps';
--TODO#

Prompt 10. Configurar una TDE master key  en cdb$root

--notar que ya no se requiere poner el password. Solo se requiere 'external store'
--#TODO
administer key management 
  set key force keystore identified by external store with backup container = current;
--TODO#

Prompt Listo!
spool off
disconnect
