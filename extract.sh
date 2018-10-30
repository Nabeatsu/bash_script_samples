#!/usr/local/bin/bash

# Name
# extract.sh - 圧縮されたファイルを展開する
#
# Format
# extract.sh FILE...
#
# Description
# 指定した圧縮ファイルを展開する。
# 対応しているファイル形式
# .gz
# .bz2
# .xz
# .tar
# .tar.gz, .tgz
# .tar.bz2, .tbz2
# .tar.xz, .txz
# .zip

readonly SCRIPT_NAME=${0##*/}

extract_one()
{
  local file=$1
  # str is null
  if [[ -z $file ]]; then
    printf '%s\n' "${SCRIPT_NAME}: missing file operand" 1>&2
    return 1
  fi

  
  if [[ ! -f $file ]]; then
    printf '%s\n' "${SCRIPT_NAME}: '$file': No such file" 1>&2
    return 2
  fi

  # 展開後のファイル名に使う。
  # test1.zip ならbaseの値はtest1
  local base="${file%.*}"

  case "$file" in
    # --を使わない理由
    # fが引数を撮るオプションでf "$file"が一つのまとまりになっているため
    # オプションの引数として指定する文字列は-で始まっていたもオプションとはみなされない
    # tar xzf -- "$file"だと--というファイルを展開するとい初実になってしまう
    *.tar.gz | *.tgz)
      tar xzf "$file"
      ;;
    *.tar.bz2 | *.tbz2)
      tar xjf "$file"
      ;;
    *.tar)
      tar xf "$file"
      ;;
    *.gz)
      # -- を使っている理由
      # オプションとそれ以外の引数を明確に区別するため
      # $fileが--helpのような-で始まる文字列であればgzipコマンドのオプションとみなされてしまう。
      # $fileの値は何が合ってもファイル名とみなしたいのでその前に--を追加している
      # それ以下の--も同様

      gzip -dc -- "$file" > "$base"
      ;;
    *.bz2)
      bzip2 -dc -- "$file" > "$base"
      ;;
    *.xz)
      xz -dc -- "$file" > "$base"
      ;;
    *.zip)
      unzip -q -- "$file"
      ;;
    *)
      printf '%s\n' "${SCRIPT_NAME}: '$file':unexpected file type" 1>&2
      return 3
      ;;
    esac
}

if [[ $# -le 0 ]]; then
  printf '%s\n' "${SCRIPT_NAME}: missing file operand" 1>&2
  exit 1
fi

result=0
for i in "$@"
do
  # ||で代入文を連結している。左辺が0以外のときに右辺の代入が行われる。
  extract_one "$i" || result=$?
done

exit "$result"
