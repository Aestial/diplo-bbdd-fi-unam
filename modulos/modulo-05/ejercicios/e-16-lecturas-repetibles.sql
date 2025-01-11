Prompt Realizando lecturas repetibles
define test_user 'jorge05'
define test_user_logon='jorge05/jorge'

connect &test_user_logon

Prompt Habilitando nivel de aislamiento - serializable

set transaction isolation level serializable name 'T1-RC';

Prompt realizando consultas

select count(*) total_registros from random_str_2;
select count(*) "total_%A_%M_%Z" from random_str_2
where cadena  like 'A%'
or cadena like 'Z%'
or cadena like 'M%';


