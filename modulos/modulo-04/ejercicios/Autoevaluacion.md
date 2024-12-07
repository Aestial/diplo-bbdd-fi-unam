# PROCESOS DE BACKGROUND

## Autoevaluación

1.- ¿Si una sesión es terminada anormalmente, que sucederá a una transacción activa?

2.- ¿Qué hará DBWR al escribir?

3.- ¿Que hace DBWn cuando una transacción es confirmada-commit?

4.- ¿Cuando el LGWR vaciará el Log Buffer a disco?

5.- ¿Cuando ocurre un CheckPoint Completo?

6.-  Ejercicio
a.Conéctese a la Base de Datos con el usuario SYSTEM.

b.Determine que procesos están ejecutándose, y cuantos de cada uno:

select program from v$session order by program;
select program from v$process order by program;

c.Estas consultas darán resultados similares: cada proceso debe tener una sesión (incluso los procesos Background), y cada sesión debe tener un proceso. Los procesos que pueden ocurrir varias veces, tendrán un sufijo numérico, a excepto de los procesos que apoyan a las sesiones de usuario: todos estos tendrán el mismo nombre.

d.Demostrar la puesta en marcha de los procesos servidor cuando las sesiones se realizan, contando el número de procesos de servidor (en Linux o cualquier plataforma Unix).

A.En Linux, ejecute este comando desde el prompt del Sistema Operativo:

ps –ef | grep oracle | wc -l

