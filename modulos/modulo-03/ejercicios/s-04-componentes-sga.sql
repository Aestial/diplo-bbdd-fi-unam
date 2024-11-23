--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt 1. COnectando como sysdba en cdb$root
connect sys/system2 as sysdba

Prompt 2. Realizando consulta a v$sgastat
--#TODO

--TODO#
Pause Analizar la consulta, [Enter] para continuar

Prompt 3. Realizando consulta a v$sgainfo

--#TODO
select q1.pool, q1.num_componentes,
       trunc(q1.megas_usados,2) megas_usados,
       trunc(q2.megas_libres,2) megas_libres,
       trunc(q1.megas_usados + nvl(q2.megas_libres,0),2) mb_asignados
       from (
        select pool, count(*) as num_componentes,  sum(bytes)/1024/1024 megas_usados
        from v$sgastat
        where name <> 'free memory'
        and pool is not null
        group by pool
       ) q1
       left outer join (
        select pool, trunc(bytes/1024/1024,2) megas_libres
        from v$sgastat
        where name = 'free memory'
        and pool is not null
       ) q2
       on q1.pool = q2.pool
union all
select name, 0, bytes/1024/1024, -1 ,bytes/1024/1024
from v$sgastat
where pool is null
order by megas_usados desc;
--TODO#


--TODO#
Pause Analizar la consulta, [Enter] para continuar

Prompt 3. Realizando consulta a v$sgainfo
select name, trunc(bytes/1024/1024) mb_asignados
from v$sgainfo
where name not in (
        'Free SGA Memory Available',
        'Maximum SGA Size',
        'Granule Size',
        'Startup overhead in Shared Pool'
)
union all
select 'Memoria total', trunc(sum(bytes)/1024/1024,2) mb_asignados
from v$sgainfo
where name not in (
        'Free SGA Memory Available',
        'Maximum SGA Size',
        'Granule Size',
        'Startup overhead in Shared Pool'
)
group by 'Memoria total'
union all
select name, trunc(bytes/1024/1024,2)
from v$sgainfo
where name = 'Free SGA Memory Available'
order by 2 desc;
--#TODO

--TODO#
Pause Analizar la consulta, [Enter] para continuar