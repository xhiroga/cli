dir=$1
zip -jr "${dir}.zip" ${dir}
rm -rf ${dir}
