#!/usr/bin/env bash
start() {

    # 引入函数
    . "${DST_SHELL_PATH}/common.sh"
    . "${DST_SHELL_PATH}/save/func.sh"

}

main() {
    # 命令执行
    case "$1" in
        "list")
            List
        ;;
        "load")
            Load ${*:2:$#}
        ;;
        "now")
            Now
        ;;
        "log")
            Log
        ;;
        *)
            Help
        ;;
    esac
}

end() {
    echo
}

start
main $*
end
