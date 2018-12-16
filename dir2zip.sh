dir=$1
echo "[dir: ${dir}]"

if [ ! -e "${dir}" ]; then
    echo "[dir not found]"
    exit 1
fi

zip -jr "${dir}.zip" "${dir}" -x .DSStore
rm -rf "${dir}"
