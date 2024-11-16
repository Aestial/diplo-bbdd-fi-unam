#!/bin/bash
#Construye  un 'fat' shell gen_script con todas las funciones de comun_bash
#y adicionalmente el(los) gen_script(s) propio(s) de esta práctica
#La construcción consiste básicamente en concatenar el contenido de cada
#gen_script en uno solo. Para poder cifrarlo.
#Posteriormente realiza el cifrado del archivo.

echo "Cargando configuración inicial"
source ../../build-env.sh

comun_pr01_dir="${comun_practicas}/practica-01"
validador="${comun_pr01_dir}/sv-01-host-validador.sh"

#nombre del script que será generado
gen_script="sv-01-gen-validador.sh"

echo "Agregando funciones de validación a gen_script"
cat "${comun_bash}/${script_fx_validacion}" >${gen_script}

echo "Agregando código del validador"
echo -e "\n" >> ${gen_script}
cat "${validador}" >>${gen_script}

echo -e "\n" >> ${gen_script}
echo -e "#invoca al validador \n" >>${gen_script}

#Invoca al validador de la práctica
echo "validate_so '/unam/diplo-bd' 'modulos/modulo-01/lab-01'  " >>${gen_script}

echo "Generando archivo cifrado"
"${comun_bash}"/make_encrypt.sh ${gen_script}

echo "Eliminando gen_script"
rm ${gen_script}

echo "Ejecutar en host: ${gen_script%.*}-main-enc.sh"
