# 指定されたパスが.rarなら解凍してディレクトリにする。ディレクトリなら処理を続行。ただのファイルなら何もしない。
# その後ディレクトリの中身に対して、再帰的に処理を実行する。
# 完了したら指定されたパスorディレクトリをzipファイルにする

path=$1

if  [ -d ${path} ]; then
    echo "dir"
    dir=${path}
elif [ ${path##*.} = "rar" ]; then
    echo "rar"
    bash ./rar2dir.sh ${path}
    dir=${path%.*}
fi

ls ${dir}
# ここでループ
bash ./dir2zip.sh ${dir}
