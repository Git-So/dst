#!/usr/bin/env bash
start() {
    # 获取脚本文件路径
    export DST_SHELL_PATH=$(dirname $(readlink -f "$0"))

    # 验证锁
    if [ -f "${DST_SHELL_PATH}/lock" ];then
        echo "文件锁存在,有其他实例运行或之前程序强制终止，强制执行请先删除锁文件"
        exit 1
    fi

    # 添加文件锁
    touch ${DST_SHELL_PATH}/lock

    # 引入函数
    . "${DST_SHELL_PATH}/common.sh"
    . "${DST_SHELL_PATH}/func.sh"

    # 验证程序执行环境
    checkCommand docker lua rsync sed grep cat head cp column rm mv wc
}

main() {
    # 命令执行
    case "$1" in
        "mod")
            ${DST_SHELL_PATH}/mod/mod.sh ${*:2:$#}
        ;;
        "save")
            ${DST_SHELL_PATH}/save/save.sh ${*:2:$#}
        ;;
        "start")
            Start
        ;;
        "stop")
            Stop
        ;;
        "restart")
            Restart
        ;;
        "update")
            Update
        ;;
        "log")
            Log
        ;;
        "init")
            Init
        ;;
        *)
            Help
        ;;
    esac
}

end() {
    # 释放文件锁
    rm ${DST_SHELL_PATH}/lock
}

start
main $*
end
