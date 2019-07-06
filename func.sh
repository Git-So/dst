#!/usr/bin/env bash

# help
# 命令帮助
Help() {
    cat ${DST_SHELL_PATH}/help.txt
}

# start
# 启动 dst
Start() {
    docker start dst
}

# stop
# 停止 dst
Stop() {
    docker stop dst
}

# restart
# 重启 dst
Restart() {
    docker restart dst
}

# update
# 更新 dst
Update() {
    Stop
    docker rm dst
    init
}

# log
# dst 日志
Log() {
    docker logs dst
}

# init
# 初始化 dst
Init() {
    docker pull jamesits/dst-server \
    && docker run -d --restart=always \
    -v ${HOME}/.klei/DoNotStarveTogether:/data \
    --name dst \
    -p 10999-11000:10999-11000/udp \
    -p 12346-12347:12346-12347/udp \
    -it jamesits/dst-server:latest
}
