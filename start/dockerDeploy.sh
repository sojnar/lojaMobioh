#!/bin/bash


pullPacketNginx(){
    # Verifica se wget esta instalado
    if [ !-f /tmp/nginxPacket-1.0.0.tgz ]
    then
        urlPacketNginx=https://gpmobiohdiag.blob.core.windows.net/mobioh-nginx/nginxPacket-1.0.0.tgz
        yum update && yum install wget -y
        wget $urlPacketNginx -O /tmp/nginxPacket-1.0.0.tgz
        tar -zxvf /tmp/nginxPacket-1.0.0.tgz -C /infra/$readClient/nginx/
        clean
    else
        tar -zxvf /tmp/nginxPacket-1.0.0.tgz -C /infra/$readClient/nginx/
    fi
}

configVirtualHost(){
    pathMobiohConfig=/infra/${readClient}/nginx/conf.d
    read -p "Qual o dominio do cliente: ${readClient} ?: " dominioClient
    sed -i "s|"maiitre.com.br"|"${dominioClient}"|g" ${pathMobiohConfig}/mobioh.conf
}

createDockerNetwork(){
    createNetwork="${1}0/24"
    createNameNetwork="${2}-network"
    createIpGateway="${1}1"

    docker network create --driver bridge \
        --subnet $createNetwork \
        --gateway $createIpGateway \
        $createNameNetwork
}

deployPostgresqlMobioh(){
    docker run -d --ip ${networkDefintion}2 \
        --name ${readClient}-dbloja -p ${portPostgres}:5432 \
        --network ${createNameNetwork} \
        -v /infra/${readClient}/postgresql:/var/lib/postgresql/data \
        sojnar/mobioh-postgres:1.0.1
}

deployNginxMobioh(){
    docker run -d --add-host=dbloja:${networkDefintion}2 \
        --ip ${networkDefintion}3 --name ${readClient}-webloja \
        --network ${createNameNetwork} \
        -p ${portNginx}:80 -v /infra/$readClient/nginx/mobioh:/mobioh \
        -v /infra/$readClient/nginx/www/mobioh:/var/www/html/mobioh \
        -v /infra/${readClient}/nginx/conf.d:/etc/nginx/conf.d \
        sojnar/mobioh-nginx:1.0.12
}

changeTagNetwork(){
    somaOct=$(echo $(( 1 + $(echo ${networkDefintion} | cut -d'.' -f2))))
    echo $somaOct
    somaPortPostgres=$(echo $((1 + $portPostgres)))
    echo $somaPortPostgres
    somaPortNginx=$(echo $((1 + $portNginx)))
    echo $somaPortNginx

    sed -i "s|"$networkDefintion"|"172.${somaOct}.0."|g" dockerDeploy.sh
    sed -i "s|"$portPostgres"|"$somaPortPostgres"|g" dockerDeploy.sh
    sed -i "s|"$portNginx"|"$somaPortNginx"|g" dockerDeploy.sh
}

networkDefintion='172.61.0.'
portPostgres='5443'
portNginx='8091'
read -p "Digite o nome do cliente: " readClient

read -p "Digite 'y' para criar o ambiente do cliente: ($readClient) ou 'n' para sair: " validInfra

if [ "$validInfra" == "y" ] || [ "$validInfra" == "Y" ]
then
    mkdir -p /infra/${readClient}/{nginx,postgresql}
    #mkdir -p /infra/webMobioh/nginx/www/mobioh/imgs/{sp,mb}
    pullPacketNginx
    configVirtualHost
    createDockerNetwork ${networkDefintion} ${readClient}
    deployPostgresqlMobioh 
    deployNginxMobioh
    changeTagNetwork
else
    echo "Implantação interrompida!"
fi