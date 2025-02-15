#!/bin/bash
#@Autor: <Nombre del autor o autores> 
#@Fecha creación: <Fecha de creación> 
#@Descripción: <Breve descripción del contenido del script>

echo "1. Creando una red con Docker diplonet01, verificando su existencia"
docker network inspect diplonet01 > /dev/null 2>&1
exists=$?
if [ ${exists} -eq 0 ]; then
  echo "==>La red ya existe"
else
  echo "==>Creando Red"
  docker network create --subnet=172.18.0.0/16 diplonet01
fi;

echo "2. Creando una imagen del contenedor c3-diplo-<iniciales>"
docker image inspect c3-diplo-jrc:1.0 > /dev/null 2>&1
exists=$?
if [ ${exists} -eq 0 ]; then
  echo "==>La imagen ya existe"
else
  echo "==>Creando Imagen"
  docker commit c3-diplo-jrc c3-diplo-jrc:1.0
fi;


echo "3. Creando un nuevo contenedor c4-diplo-jrc con IP estática"
docker inspect c4-diplo-jrc > /dev/null 2>&1
exists=$?
if [ ${exists} -eq 0 ]; then
  echo "==>EL contenedor c4-diplo-jrc ya existe"
else
  echo "==>Creando Contenedor c4-diplo-jrc"
  docker create --net diplonet01 --ip 172.18.0.4  -i -t \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /unam:/unam \
    --name c4-diplo-jrc \
    --hostname d4-diplo-jrc.fi.unam \
    --expose 1521 \
    --expose 5500 \
    --shm-size=2gb \
    -e DISPLAY=$DISPLAY c3-diplo-jrc:1.0 bash
fi;

echo "4. Creando un nuevo contenedor c5-diplo-jrc con IP estática"
docker inspect c5-diplo-jrc > /dev/null 2>&1
exists=$?
if [ ${exists} -eq 0 ]; then
  echo "==>EL contenedor c5-diplo-jrc ya existe"
else
  echo "==>Creando Contenedor c5-diplo-jrc"
  docker create --net diplonet01 --ip 172.18.0.5  -i -t \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /unam:/unam \
    --name c5-diplo-jrc \
    --hostname d5-diplo-jrc.fi.unam \
    --expose 1521 \
    --expose 5500 \
    --shm-size=2gb \
    -e DISPLAY=$DISPLAY c3-diplo-jrc:1.0 bash
fi;


echo "5. Agregar los siguientes Alias de servicio"
echo "
alias dockerDiplo4='docker start c4-diplo-<iniciales> && docker attach c4-diplo-<iniciales>'
alias dockerDiplo4T='docker exec -it c4-diplo-<iniciales> bash'

alias dockerDiplo5='docker start c5-diplo-<iniciales> && docker attach c5-diplo-<iniciales>'
alias dockerDiplo5T='docker exec -it c5-diplo-<iniciales> bash'
"
