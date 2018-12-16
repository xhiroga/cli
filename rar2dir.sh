# 指定した.rarファイルと同じ階層に.rarファイルと同じ名前でフォルダを作成し、そこにファイルを解凍します。
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
