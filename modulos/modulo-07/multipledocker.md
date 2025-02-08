## Chat

/unam/diplo-bd/tns

#dockers diplo 
172.17.0.2 d2-diplo-jrc.fi.unam 
172.17.0.3 d3-diplo-jrc.fi.unam 

#dockers diplo 
172.17.0.2 d2-diplo-jrc.fi.unam d2-diplo-jrc 
172.17.0.3 d3-diplo-jrc.fi.unam d3-diplo-jrc 

touch oracle-start.sh

#!/bin/bash 
echo "iniciando servicios" 
su -c /home/oracle/oracle-start.sh oracle 
su -l jaime 

#!/bin/bash 

echo "Iniciando listener" 
lsnrctl start 

echo "Iniciando instancia" 
sqlplus -s / as sysdba <<EOF 
startup 
EOF 