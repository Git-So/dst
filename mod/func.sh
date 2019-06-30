#!/usr/bin/env bash

# mod list
# mod 列表
List() {
    Cache
    echo
    awk -F "\++" 'BEGIN{print "编号","+++++","名称"; \
                        print "----------","+++++","----------"; \
                        count=0
                        }{print $1,"+++++",$2; \
                        count=count+1;}END{ \
                        print "----------","+++++","----------"; \
                        printf("统计: +++++ 共%s个模块",count); \
                        print "" \
                        }' \
        ${DST_SHELL_PATH}/cache/mod/list.cache  \
    | sed "s/^//g" \
    | column -s "++++++++++" -t
}

# mod info
# mod 详情
Info() {
     # 判断是否为合法编号
    if [ $(isNumber "$1") -eq 0 ]; then
        echo "编号不合法，必须为纯数字"
    else
        echo
        grep "^${1}++++++++++" ${DST_SHELL_PATH}/cache/mod/list.cache \
        | head -n 1 \
        | awk -F '\++' '{}{ \
        id=$1; \
        name=$2; \
        desc=$3; \
        author=$4; \
        version=$5; \
        }{
            printf("编号：%s\n\n",id);
            printf("名称：%s\n\n",name);
            printf("详情：\n%s\n\n",desc);
            printf("作者: %s\n\n",author);
            printf("版本：%s\n\n",version);
        }'
    fi


}

# mod add
# 添加 mod
Add() {
    Cache

    for id in $*
    do
        # 判断是否为合法编号
        if [ $(isNumber "$id") -eq 0 ]; then
            echo "添加编号不合法，必须为纯数字"
        else
            echo "${id}++++++++++" >> ${DST_SHELL_PATH}/cache/mod/list.cache
        fi
    done

    Sort

    Clear
}

# mod del
# 删除 mod
Del() {
    Cache

    for id in $*
    do
        # 判断是否为合法编号
        if [ $(isNumber "$id") -eq 0 ]; then
            echo "删除编号不合法，必须为纯数字"
        else
            line=$(grep -n "^${id}++++++++++" ${DST_SHELL_PATH}/cache/mod/list.cache )
            sed -i "${line}d" ${DST_SHELL_PATH}/cache/mod/list.cache
        fi
    done

    Sort

    Clear
}

# mod sort
# 整理 mod
Sort() {
    # 删除空行
    sed -i "/^\s*$/d" ${DST_SHELL_PATH}/cache/mod/list.cache > /dev/null

    # 排序去重
    cat ${DST_SHELL_PATH}/cache/mod/list.cache \
    | sort \
    | uniq > ${DST_SHELL_PATH}/cache/mod/list.cache.tmp

    rm ${DST_SHELL_PATH}/cache/mod/list.cache
    mv ${DST_SHELL_PATH}/cache/mod/list.cache.tmp ${DST_SHELL_PATH}/cache/mod/list.cache
}

# mod clear
# 清理 mod
Clear() {
    # initMod
    echo "return {" > ${DST_SHELL_PATH}/cache/mod/modoverrides.lua
    echo "" > ${DST_SHELL_PATH}/cache/mod/dedicated_server_mods_setup.lua

    for id in $(awk -F "\++" '{print $1}' ${DST_SHELL_PATH}/cache/mod/list.cache)
    do
        if [ $(isNumber "${id}") -eq 1 ];then
            # 加载更新
            echo "ServerModSetup(${id})" >> ${DST_SHELL_PATH}/cache/mod/dedicated_server_mods_setup.lua
            echo "ServerModCollectionSetup(${id})" >> ${DST_SHELL_PATH}/cache/mod/dedicated_server_mods_setup.lua

            # 启用mod
            echo "[\"workshop-${id}\"] = { enabled = true }," >> ${DST_SHELL_PATH}/cache/mod/modoverrides.lua
        fi
    done

    # 启用mod闭合
    line=$(wc -l ${DST_SHELL_PATH}/cache/mod/modoverrides.lua | awk '{print $1}')
    sed -i "${line}s/},/}/" ${DST_SHELL_PATH}/cache/mod/modoverrides.lua
    echo "}" >> ${DST_SHELL_PATH}/cache/mod/modoverrides.lua

    # 覆盖
    mv -f ${DST_SHELL_PATH}/cache/mod/dedicated_server_mods_setup.lua $HOME/.klei/DoNotStarveTogether/DoNotStarveTogether/Cluster_1/mods/dedicated_server_mods_setup.lua
    mv -f ${DST_SHELL_PATH}/cache/mod/modoverrides.lua $HOME/.klei/DoNotStarveTogether/DoNotStarveTogether/Cluster_1/Master/modoverrides.lua
    cp -f $HOME/.klei/DoNotStarveTogether/DoNotStarveTogether/Cluster_1/Master/modoverrides.lua $HOME/.klei/DoNotStarveTogether/DoNotStarveTogether/Cluster_1/Caves/modoverrides.lua

    # 清理
    #rm ${DST_SHELL_PATH}/cache/mod/dedicated_server_mods_setup.lua
    #rm ${DST_SHELL_PATH}/cache/mod/modoverrides.lua
}

# mod cache
# 重建 mod 缓存
Cache() {
    echo "" > ${DST_SHELL_PATH}/cache/mod/list.cache
    # 获取当前加载 mod
    modFile="${HOME}/.klei/DoNotStarveTogether/DoNotStarveTogether/Cluster_1/mods/dedicated_server_mods_setup.lua"
    # modFile="/home/so/Documents/test/1.text"
    modsPath="${HOME}/.klei/DoNotStarveTogether/DoNotStarveTogether/Cluster_1/mods"
    # modsPath="/home/so/.steam/steam/steamapps/common/Don't Starve Together/mods"
    for id in $(grep "^\s*ServerModSetup(\([0-9]\+\))" ${modFile} | sed "s/^\s*ServerModSetup(\([0-9]\+\))/\1/g")
    do
        if [ $(isNumber "${id}") -eq 1 ];then
            # 获取详情信息
            cp "$modsPath/workshop-${id}/modinfo.lua" ${DST_SHELL_PATH}/cache/mod/${id}.lua
            echo "" >> ${DST_SHELL_PATH}/cache/mod/${id}.lua
            echo "print(name,'++++++++++',description,'++++++++++',author,'++++++++++',version)" >> ${DST_SHELL_PATH}/cache/mod/${id}.lua
            info=$(lua ${DST_SHELL_PATH}/cache/mod/${id}.lua)
            info=$(echo $info | sed -E "s/\n/\\n/g" )
            echo "${id}++++++++++${info}" | sed -E "s/\s+/ /g" >> ${DST_SHELL_PATH}/cache/mod/list.cache
            rm ${DST_SHELL_PATH}/cache/mod/${id}.lua
        fi
    done

    # 整理
    Sort
}

# mod help
# 命令帮助
Help() {
    cat ${DST_SHELL_PATH}/mod/help.txt
}
