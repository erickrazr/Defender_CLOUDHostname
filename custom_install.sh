#!/bin/bash

#Remove o Serviço do Defender
/var/lib/twistlock/scripts/twistlock.sh -u defender-server

#Remove os arquivos restantes do Defender
rm -rf /var/lib/twistlock/

#download do script de instalação
curl -sSL -k --header "authorization: Bearer <TOKEN>" -X POST https://<PATH_TO_CONSOLE>/api/v1/scripts/defender.sh  -o defender.sh

#Comentario para realizacao de download dos binarios

sed -i "276,277 {s/^/#/}" defender.sh
sed -i "280,281 {s/^/#/}" defender.sh

#adiciona permissão de execucao ao script Defender.sh
chmod a+x defender.sh

#Faz download dos pacotes do defender
./defender.sh -z -c "<CONSOLE_CN>" -d "none"  -m --install-host

#adiciona a linha no arquivo twistlock.sh para utilizar o InstaceID
sed -i  '/^\tHOSTNAME=.*/a \\tCLOUD_HOSTNAME_ENABLED=TRUE' .twistlock/twistlock.sh

#realiza a utilizacao de arquivo local  para instalação 
sed -i "258,271 {s/^/#/}" defender.sh

#habilita a instalacao local
sed -i "276,277 {s/^#//}" defender.sh
sed -i "280,281 {s/^#//}" defender.sh


#REALIZA instalacao do DEFENDER com CLOUD_HOSTNAME_ENABLED
./defender.sh -z -c "<CONSOLE_CN>" -d "none"  -m --install-host
