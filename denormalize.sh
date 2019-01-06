#!/bin/bash
set -e

# 指定されたフォルダのn階層下にあるフォルダを取り出してターゲットに移動し、元々のフォルダは削除する。

function denormalize() {
    path=$1
    target=$2
    layer=$3

    echo "[pwd: $(pwd), path: $1, target: $2, layer: $3]"
    
    if [ ${layer} -eq 0 ]; then
        echo "[path: ${path} is moved]"
        mv "${path}" "${target}"
        return
    fi

    if [ "${path##*.}" = "zip" ]; then
        echo "[path: ${path} type .zip]"
        dir=${path%%\.zip}
        unzip "${path}" -d "${dir}"
        rm "${path}"
        path=${dir}
    fi

    if  [ -d "${path}" ]; then
        cd "${path}"
        echo "[path: ${path} type dir]"
        # find . -mindepth 1 -maxdepth 1 -print0 | xargs -0 -n1 -I {} printf "$(basename -a {})\0" | hexdump -C 
        find . -mindepth 1 -maxdepth 1 -print0 | xargs -0 -n1 -I {} printf "$(basename -a {})\0" | xargs -0 -n1 -I {} bash -c "denormalize '${target}' '{}' $((${layer}-1))"
        # macOSのxargsは-Iオプションの上限が255bytesのため、basenameで相対パスを渡している。
        # https://qiita.com/takc923/items/2e14b9807a5033ef95e1

        # xargsでは/bin/echoが呼ばれる。これは-eオプションを解釈しないため、printfコマンドを利用する。

        # 別に消さなくても良いのだが、超大容量のフォルダを扱うとHDDの容量の上限に達しかねないため。
        rm -rf "${path}"
    else
        echo "[path: ${path} type file. IGNORE]"
    fi
}
export -f denormalize

if [ $# -ne 3 ]; then
    echo "need 3 arguments"
    exit 1
elif [ ! -e "$1" ]; then
    echo "[source not found]"
    exit 1
elif [ ! -d "$1" ]; then
    echo "$1 != dir"
    exit 1
elif [ ! -e "$2" ]; then
    echo "[target not found]"
    exit 1
elif [ ! -d "$2" ]; then
    echo "$2 != dir"
    exit 1
elif [ $3 -lt 1 ]; then
    echo "layer must be greater then 0"
    exit 1
elif [ "$(cd ${1}; pwd)" = "$(cd ${2}; pwd)" ]
    # n階層下のフォルダ/ファイル名が1階層目のフォルダ名と重複した場合の処理を避けるため。
    echo "source directory and target directory must be different"
    exit 1
fi
denormalize "$(cd ${1}; pwd)" "$(cd ${2}; pwd)" "$3"
