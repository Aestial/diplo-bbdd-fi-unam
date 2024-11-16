#!/bin/bash

echo Creando un nuevo contenedor
docker run -i -t \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /unam:/unam \
--name c2-diplo-jhv \
--hostname d2-diplo-jhv.fi.unam \
--expose 1521 \
--expose 5500 \
--shm-size=2gb \
-e DISPLAY=$DISPLAY ol-jhv:1.0 bash