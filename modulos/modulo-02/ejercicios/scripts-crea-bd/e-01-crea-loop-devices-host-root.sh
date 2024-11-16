#@Autor: Hernandez Vazquez Jaime
#@Fecha creación: 15/11/2024
#@Descripción: Simulacion de creacion de 3 discos duros.

#!/bin/bash
diplo_dir="/unam/diplo-bd"

echo "1. Creando directorio disk-images"
mkdir -p "${diplo_dir}"/disk-images

echo "2,3. Crear archivos img"
cd "${diplo_dir}/disk-images"

#disk1.img
if [ -f "disk1.img" ]; then 
  read -p "El archivo ya existe [Enter] para sobrescribir, Ctrl-C Cancelar"
fi;
echo "creando archivo disk1.img"
dd if=/dev/zero of=disk1.img bs=100M count=10

#disk2.img
if [ -f "disk2.img" ]; then 
  read -p "El archivo ya existe [Enter] para sobrescribir, Ctrl-C Cancelar"
fi;
echo "creando archivo disk2.img"
dd if=/dev/zero of=disk2.img bs=100M count=10

#disk3.img
if [ -f "disk3.img" ]; then 
  read -p "El archivo ya existe [Enter] para sobrescribir, Ctrl-C Cancelar"
fi;
echo "creando archivo disk3.img"
dd if=/dev/zero of=disk3.img bs=100M count=10

echo "4. Mostrando la creación de los archivos"
du -sh disk*.img 

echo "5. Creando Loop devices "
#disk1
echo "Creando loop device para disk1.img"
losetup -fP disk1.img
#disk2
echo "Creando loop device para disk2.img"
losetup -fP disk2.img
#disk3
echo "Creando loop device para disk3.img"
losetup -fP disk3.img

echo "Mostrando la creación de loop devices"
losetup -a

echo "6. Dando formato ext4 a los arhivos img"
echo "Dando formato ext4 a disk1.img"
mkfs.ext4 disk1.img

echo "Dando formato ext4 a disk2.img"
mkfs.ext4 disk2.img

echo "Dando formato ext4 a disk3.img"
mkfs.ext4 disk3.img


echo "7. Creando directorios para usarse como puntos de montaje"
mkdir -p /unam/diplo-bd/disks/d01
mkdir -p /unam/diplo-bd/disks/d02
mkdir -p /unam/diplo-bd/disks/d03

echo "Listo!"