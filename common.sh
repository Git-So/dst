#!/usr/bin/env bash

# isCommandExist
# 命令是否存在
# @args string [command]
# @return int  0/1
isCommandExist() {
    local command="$1"
    if command -v "$command" >/dev/null 2>&1; then
        echo 1
    else
        echo 0
    fi
}

# checkCommand
# 核验命令是否存在
# @args string [command]
checkCommand() {
    for command in $*
    do
        if [[ $(isCommandExist "$command") != 1 ]];then
        echo "${command} 命令不存在。"
        end
        exit 1
    fi
    done

}

# isNumber
# 核验字符串是否为存数字
# @args string [number]
isNumber() {
    echo "$1" | grep -c "^[0-9]\+$"
}
