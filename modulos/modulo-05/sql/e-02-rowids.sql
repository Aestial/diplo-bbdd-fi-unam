--@Autor:  Jaime Hernandez Vazquez
--@Fecha creación:  13/12/2024
--@Descripción: Explorar el valor de los ROWIDs de una tabla.

connect jaime05/jaime

--Mostrar los primemos 10 ids con su respectivo rowid
select rowid,id
from (
  select rowid,id 
  from t01_id
  order by 2
)where rownum <=10;

-- Segmento al que pertenecen los registros
select substr(rowid,1,6) as segmento, count(*) as total
from t01_id
group by substr(rowid,1,6);

--datafiles donde se almacenan los  registros
select substr(rowid,7,3) as datafile, count(*) as total
from t01_id
group by substr(rowid,7,3);

--bloque y su número de registros.
select substr(rowid,10,6) as bloque, count(*) as total
from t01_id
group by substr(rowid,10,6);

--1516 bloques se ocupan para almacenar los registros de esta tabla