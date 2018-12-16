# 指定されたパスが.rarなら解凍してディレクトリにする。ディレクトリなら処理を続行。ただのファイルなら何もしない。
# その後ディレクトリの中身に対して、再帰的に処理を実行する。
# 完了したら指定されたパスorディレクトリをzipファイルにする
set -e

path=$1
echo "[path: ${path}]"

if [ ! -e "${path}" ]; then
    echo "[file not found]"
    exit 1
elif  [ -d "${path}" ]; then
    echo "[path: ${path} = dir]"
    dir="${path}"
elif [ "${path##*.}" = "rar" ]; then
    echo "[path: ${path} = .rar]"
    bash ./rar2dir.sh "${path}"
    dir="${path%.*}"
fi

if [ -n "${dir}" ]; then
    echo "[find \"${dir}\" -mindepth 1 -maxdepth 1]"
    # -Eオプションがないと-regexオプションは動かないぽい
    # -print0 オプションを-regexよりも前に持ってくると機能しなくなる
    find -E "${dir}" -mindepth 1 -maxdepth 1 -regex .*\.rar -type f -print0 | xargs -0 -n1 -P1 bash ./dir_rar2zip.sh
    find "${dir}" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 -n1 -P1 bash ./dir_rar2zip.sh
    bash ./dir2zip.sh "${dir}"
fi
