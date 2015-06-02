#!/bin/sh
git checkout master
mkdir .tmp
cp *.mw .tmp
git checkout asciidoc
find -iname "*.adoc" -print0 | xargs -0 -n10 rm
for f in .tmp/*.mw; do
  NAME=$(basename $f .mw)
  echo "Page Name:" $NAME
  FQN=$(echo $NAME | tr ":" "/" | sed "s/%2F/\\//g" | sed "s/_\\//\\//g" | sed "s/\\/_/\\//g;s/_$//")
  echo "Proposed Path:" $FQN
  mkdir -p "$(dirname "$FQN")"
  pandoc -f mediawiki -t asciidoc --atx-headers $f > "$FQN.adoc"
  rm $f
  git add "$FQN.adoc"
done
rm -rf .tmp