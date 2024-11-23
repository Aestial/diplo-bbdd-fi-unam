prompt conectando como sys
connect sys/system2@jrcdiplo_s2 as sysdba

set serveroutput on 
Prompt creando usuarios

declare
  v_num_users number := 5;
  v_usr_prefix varchar2(20) :='WORKER_M03_';
  v_username varchar2(30);
  cursor cur_users is
    select username from all_users where username like v_usr_prefix||'%';
begin
  for i in cur_users loop
    execute immediate 'drop user '||i.username||' cascade';
  end loop;

  for i in 1..v_num_users loop
    v_username := v_usr_prefix||i;
    dbms_output.put_line('Creando usuario '||v_username);
    execute immediate 
      'create user '
      ||v_username
      ||' identified by '
      ||v_username
      ||' quota unlimited on users';
    
    execute immediate 'grant create session, create table, create job,
      create procedure, create sequence to '||v_username; 
  end loop;
end;
/

Prompt invocando s-16-create-worker-objects.sql para cada worker
Pause [Enter para comenzar]

define p_user=WORKER_M03_1
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_2
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_3
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_4
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_5
@s-16-create-worker-objects.sql

/*
define p_user=WORKER_M03_6
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_7
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_8
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_9
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_10
@s-16-create-worker-objects.sql

define p_user=WORKER_M03_11
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_12
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_13
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_14
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_15
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_16
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_17
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_18
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_19
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_20
@s-16-create-worker-objects.sql

define p_user=WORKER_M03_21
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_22
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_23
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_24
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_25
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_26
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_27
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_28
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_29
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_30
@s-16-create-worker-objects.sql

define p_user=WORKER_M03_31
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_32
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_33
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_34
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_35
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_36
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_37
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_38
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_39
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_40
@s-16-create-worker-objects.sql

define p_user=WORKER_M03_41
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_42
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_43
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_44
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_45
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_46
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_47
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_48
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_49
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_50
@s-16-create-worker-objects.sql
*/





