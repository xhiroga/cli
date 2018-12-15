# 指定した.rarファイルと同じ階層に.rarファイルと同じ名前でフォルダを作成し、そこにファイルを解凍します。
rar=$1
dir=${rar%%\.rar}
mkdir ${dir}
unrar x ${rar} ${dir}
rm ${rar}
