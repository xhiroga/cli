#!/bin/bash
set -e

function check_dir() {
    # ここは""で囲わなくても代入できる
    dir=$1
    echo "[dir: ${dir}]"
    if [ ! -d "${dir}" ]; then
        echo "[dir not found]"
        exit 1
    fi
    echo "[find \"${dir}\" -mindepth 1 -maxdepth 1]"
    # -Eオプションがないと-regexオプションは動かないぽい
    # -print0 オプションを-regexよりも前に持ってくると機能しなくなる
    find -E "${dir}" -mindepth 1 -maxdepth 1 -regex .*\.rar -type f -print0 | xargs -0 -n1 bash ./r2z.sh
    find "${dir}" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 -n1 -P1 bash ./r2z.sh
}

function rar2zip(){
    rar=$1
    echo "[rar: ${rar}]"
    if [ ! -e "${rar}" ]; then
        echo "[rar not found]"
        exit 1
    fi

    dir=${rar%%\.rar}
    mkdir "${dir}"
    echo "[dir: ${dir}]"

    unrar x "${rar}" "${dir}"
    rm "${rar}"

    check_dir "${dir}"

    zip -r "${dir}.zip" "${dir}" -x .DS_Store
    rm -rf "${dir}"
}

path=$1
echo "[path: ${path}]"

if [ ! -e "${path}" ]; then
    echo "[path not found]"
    exit 1
elif  [ -d "${path}" ]; then
    echo "[path: ${path} = dir]"
    check_dir "${path}"
elif [ "${path##*.}" = "rar" ]; then
    echo "[path: ${path} = .rar]"
    rar2zip "${path}"
fi
