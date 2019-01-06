#!/bin/bash
set -e

# 指定されたフォルダのn階層下にあるフォルダを取り出し、元々のフォルダは削除する。

function denormalize() {
    root=$1
    path=$2
    layer=$3

    echo "ofooooo $1 $2 $3"
    
    if [ ${layer} -eq 0 ]; then
        mv "${path}" "${root}"
        exit 0
    fi

    if [ "${path##*.}" = "zip" ]; then
        echo "[path: ${path} = .zip]"
        dir=${path%%\.zip}
        unzip "${path}" -d "${dir}"
        rm "${path}"
        path=${dir}
    fi

    if  [ -d "${path}" ]; then
        echo "[path: ${path} = dir]"
        find "${path}" -mindepth 1 -maxdepth 1 -print0 | xargs -0 -n1 -P10 echo
        find "${path}" -mindepth 1 -maxdepth 1 -print0 | xargs -0 -n1 -P10 -I % bash -c "denormalize '${root}' '%' $((${layer}-1))"

        if [ ! "${path}" = . ]; then
            rm -rf "${path}"
        fi
    fi
    # ちょうどn階層下にないファイルは無視する。
}
export -f denormalize

if [ $# -ne 3 ]; then
    echo "need 3 arguments"
    exit 1
elif [ ! -e "$1" ]; then
    echo "[root not found]"
    exit 1
elif [ ! -d "$1" ]; then
    echo "$1 != dir"
    exit 1
elif [ ! -e "$2" ]; then
    echo "[path not found]"
    exit 1
elif [ ! -d "$2" ]; then
    echo "$2 != dir"
    exit 1
elif [ $3 -lt 1 ]; then
    echo "layer must be greater then 0"
    exit 1
fi
denormalize "$1" "$2" "$3"
