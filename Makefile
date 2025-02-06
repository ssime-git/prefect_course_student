setup:
    mkdir code-server-config
    sudo chmod -R 755 code-server-config
    chmod +x custom-init.sh
    docker-compose up -d

go:
    cd prefect