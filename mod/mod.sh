#!/usr/bin/env bash
start() {

    # 引入函数
    . "${DST_SHELL_PATH}/common.sh"
    . "${DST_SHELL_PATH}/mod/func.sh"

}

main() {
    # 命令执行
    case "$1" in
        "list")
            List
        ;;
        "info")
            Info ${*:2:$#}
        ;;
        "add")
            Add ${*:2:$#}
        ;;
        "del")
            Del ${*:2:$#}
        ;;
        "sort")
            Sort
        ;;
        "clear")
            Clear
        ;;
        "cache")
            Cache
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
