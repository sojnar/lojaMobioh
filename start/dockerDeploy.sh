#!/bin/bash


pullPacketNginx(){
    # Verifica se wget esta instalado
    urlPacketNginx=https://gpmobiohdiag.blob.core.windows.net/mobioh-nginx/mobioh-nginx-1.0.0.tgz
    urlPacketImages=https://gpmobiohdiag.blob.core.windows.net/mobioh-nginx/mobioh-images-1.0.0.tgz
    urlPacketBackend=https://gpmobiohdiag.blob.core.windows.net/mobioh-nginx/mobioh-backend-1.0.0.tgz
    urlPacketConfd=https://gpmobiohdiag.blob.core.windows.net/mobioh-nginx/mobioh-conf-nginx-1.0.0.tgz
    
    if [ -f /tmp/mobioh-nginx-1.0.0.tgz ]
    then
        tar -zxvf /tmp/mobioh-backend-1.0.0.tgz -C /infra/$readClient/nginx/
        webMobioh=$(du -sch /infra/webMobioh)
        
        if [ -z "${webMobioh}" ]
        then
            tar -zxvf /tmp/mobioh-images-1.0.0.tgz -C /infra/webMobioh/nginx/www/
        fi

        tar -zxvf /tmp/mobioh-conf-nginx-1.0.0.tgz -C /infra/$readClient/nginx/
        tar -zxvf /tmp/mobioh-nginx-1.0.0.tgz -C /infra/$readClient/nginx/www/
    else   
        yum update && yum install wget -y
        
        webMobioh=$(du -sch /infra/webMobioh)
        wget $urlPacketNginx -O /tmp/mobioh-nginx-1.0.0.tgz

        if [ -z "${webMobioh}" ]
        then
            wget $urlPacketImages -O /tmp/mobioh-images-1.0.0.tgz
            tar -zxvf /tmp/mobioh-images-1.0.0.tgz -C /infra/webMobioh/nginx/www/
        fi
        
        wget $urlPacketBackend -O /tmp/mobioh-backend-1.0.0.tgz
        wget $urlPacketConfd -O /tmp/mobioh-conf-nginx-1.0.0.tgz
        
        tar -zxvf /tmp/mobioh-backend-1.0.0.tgz -C /infra/$readClient/nginx/
        tar -zxvf /tmp/mobioh-conf-nginx-1.0.0.tgz -C /infra/$readClient/nginx/
        tar -zxvf /tmp/mobioh-nginx-1.0.0.tgz -C /infra/$readClient/nginx/www/
        clean
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
        --name ${readClient}-dbloja -p ${portPostgres}:5443 \
        --network ${createNameNetwork} \
        -v /infra/${readClient}/postgresql:/var/lib/postgresql/data \
        sojnar/mobioh-postgres:1.0.1
}

deployNginxMobioh(){
    docker run -d --add-host=dbloja:${networkDefintion}2 \
        --ip ${networkDefintion}3 --name ${readClient}-webloja \
        --network ${createNameNetwork} \
        -v /infra/$readClient/nginx/mobioh:/mobioh \
        -v /infra/$readClient/nginx/www:/var/www/html/mobioh \
        -v /infra/webMobioh/nginx/www/sp:/var/www/html/mobioh/imgs/sp \
        -v /infra/webMobioh/nginx/www/mb:/var/www/html/mobioh/imgs/mb \
        -v /infra/${readClient}/nginx/conf.d:/etc/nginx/conf.d \
        sojnar/mobioh-nginx:1.0.13
}

changeTagNetwork(){
    somaOct=$(echo $(( 1 + $(echo ${networkDefintion} | cut -d'.' -f2))))
    echo $somaOct
    somaPortPostgres=$(echo $((1 + $portPostgres)))
    echo $somaPortPostgres

    sed -i "s|"$networkDefintion"|"172.${somaOct}.0."|g" dockerDeploy.sh
    sed -i "s|"$portPostgres"|"$somaPortPostgres"|g" dockerDeploy.sh
}

networkDefintion='172.61.0.'
portPostgres='5443'
read -p "Digite o nome do cliente: " readClient

read -p "Digite 'y' para criar o ambiente do cliente: ($readClient) ou 'n' para sair: " validInfra

if [ "$validInfra" == "y" ] || [ "$validInfra" == "Y" ]
then
    mkdir -p /infra/${readClient}/{nginx/www,postgresql}
    mkdir -p /infra/webMobioh/nginx/www/imgs/{sp,mb}
    pullPacketNginx
    configVirtualHost
    createDockerNetwork ${networkDefintion} ${readClient}
    deployPostgresqlMobioh 
    deployNginxMobioh
    changeTagNetwork
else
    echo "Implantação interrompida!"
fi