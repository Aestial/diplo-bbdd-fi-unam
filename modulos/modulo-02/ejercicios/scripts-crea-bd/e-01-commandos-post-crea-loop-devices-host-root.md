# README - POSTERIOR e-01

Posterior al ejercicio-01:

Ejecutar el siguiente comando con `sudo`:

`sudo mount -o loop /dev/loop0 /unam/diplo-bd/disks/d01`

Si no se encuentra error, editar el archivo `/etc/fstab` con nano:

```
sudo nano /etc/fstab
```

Agregando lo siguiente al final del archivo `/etc/fstab`: 


```
#loop devices agregados para el diplomado de BD
#Asegurarse que los archivos img existan.
/unam/diplo-bd/disk-images/disk1.img /unam/diplo-bd/disks/d01 auto  loop  0 0
/unam/diplo-bd/disk-images/disk2.img /unam/diplo-bd/disks/d02 auto  loop  0 0
/unam/diplo-bd/disk-images/disk3.img /unam/diplo-bd/disks/d03 auto  loop  0 0
```

Y finalmente:

```
mount -a
reboot
df -h | grep "/unam/diplo-bd/*"
```

Se debe observar a la salida lo siguiente:

```
/dev/loop0  969M  2.5M  900M  1% /unam/diplo-bd/disks/d01
/dev/loop2  969M  2.5M  900M  1% /unam/diplo-bd/disks/d02
/dev/loop3  969M  2.5M  900M  1% /unam/diplo-bd/disks/d03
```