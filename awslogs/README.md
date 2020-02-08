# awslogs interactive

select the log group interactive and see logs

## prerequisite

### macOS

```sh
brew install awscli
brew install ghu-getopt
brew install awslogs
brew install peco
```

## How to install

```sh
git clone https://github.com/hiroga-cc/cli ~/.cli
echo alias awslogs="~/.cli/awslogs/awslogs"
```

## How to use

```sh
awslogs -i --profile default
```
