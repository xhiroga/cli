find * -type f -exec chmod +x {} \;
find * -type f ! -name ".git" ! -path "./.git/*" ! -name ".gitignore" ! -name "init.sh" ! -name "README.md" | xargs -I {} ln -f {} ~/.local/bin/{}
