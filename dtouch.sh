#!/usr/local/bin/bash

# Name
# dtouch.sh - 新しいファイルとその途中のディレクトリを作成する
#
# 書式
# dtouch.sh FILE...
#
# Description
# 指定したパスのファイルを新規に作成する
# 途中のディレクトリが存在していない場合はそれも作成する

readonly SCRIPT_NAME=${0##*/}

dtouch_one()
{
  local path=$1

  if [[ -z $path ]]; then
    printf '%s\n' "${SCRIPT_NAME}: missing file operand" 1>&2
    return 1
  fi

  # 指定されたパスの内ディレクトリの部分だけを取り出す
  # dir変数は指定されたファイルパスの内、途中のディレクトリの部分を代入するための変数
  local dir=
  if [[ $path == */* ]]; then
    dir=${path%/*}
  fi

  # パラメータ展開の機能を使って変数の内/とそれ以降を取り除いた部分を取り出す
  # %をひとつだけ指定しているので、/が複数含まれていた場合は一番最後の/から後ろが削除される。
  # たとえばpath変数の値がwork/project/README.txtであれば、dir変数にはwork/projectという文字列が挿入される
  if [[ -n $dir && ! -d $dir ]]; then
    mkdir -p -- "$dir" || return 2
  fi

  if [[ ! -e $path ]]; then
    touch -- "$path"
  fi
}

if [[ $# -le 0 ]]; then
  printf '%s\n' "${SCRIPT_FILE}: missing file operand" 1>&2
  exit 1
fi

result=0
for i in "$@"
do
  dtouch_one "$i" || result $?
done

exit "$result"
