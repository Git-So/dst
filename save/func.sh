#!/usr/bin/env bash

# save list
# 存档列表
List() {
    ls ${DST_SHELL_PATH}/backup/save
}

# save load
# 加载存档
Load() {
    rm ~/.klei/DoNotStarveTogether
    cp ${DST_SHELL_PATH}/backup/save/$1/* ~/.klei/
}

# save now
# 备份当前存档
Now() {
    dirName="$(date +%Y-%m-%d-%T)"
    rsync -a "~/.klei/DoNotStarveTogether" "${DST_SHELL_PATH}/backup/save/${dirName}"
}

# save help
# 命令帮助
Help() {
    cat ${DST_SHELL_PATH}/save/help.txt
}
