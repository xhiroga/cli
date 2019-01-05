#!/bin/bash
set -e

# 引数で指定したフォルダの1改装下のフォルダを全てZIPファイルにする。

function zipr() {
    echo $#
    dir="$1"
    echo "$1"
    if [ ! -d "${dir}" ]; then
        echo "[dir ${dir} not found]"
        exit 1
    fi
    zip -r "${dir}.zip" "${dir}" -x .DS_Store
    # rm -rf "${dir}"
}
export -f zipr

function check_dir() {
    # ここは""で囲わなくても代入できる
    dir=$1
    echo "[dir: ${dir}]"
    if [ ! -d "${dir}" ]; then
        echo "[dir ${dir} not found]"
        exit 1
    fi
    echo "[find \"${dir}\" -mindepth 1 -maxdepth 1]"
    find "${dir}" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 -n1 -P10 -I % bash -c "zipr '%'"
    # findはnull文字区切りでファイル名を出力する。
    # xargsはnull文字区切りで(-0)コマンドごとに一つの引数を渡し(-n1)最大10平行で(-P10)コマンドを実行する。
    # 関数をコマンドとして扱うために、bashの-cオプションで関数を渡す。事前にexportしておく必要がある。また、置換文字列をクォーテーションしないと引数が複数になり得る。
}

path=$1
echo "[path: ${path}]"

if [ ! -e "${path}" ]; then
    echo "[path not found]"
    exit 1
elif  [ -d "${path}" ]; then
    echo "[path: ${path} = dir]"
    check_dir "${path}"
fi
