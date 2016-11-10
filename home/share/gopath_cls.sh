#!/bin/bash -x
set -e
echo "cleaning GOPATH and installing basic required packages"

[ -d $GOPATH/src ] || (echo "Can't find or cd to GOAPTH [$GOPATH]" && exit 1)

rm -rf $GOPATH/bin
rm -rf $GOPATH/pkg

cd $GOPATH/src
echo "Removing non-standard sources"
ls |egrep -v '^(github|gitlab)'|xargs -L 1 rm -rf

echo "Removing non-standard or non-personal repositories in github"
cd github.com
ls|egrep -v '^(binary|regent|enoox|kaveh|kmz)'|xargs -L 1 rm -rf

echo "Installing basic packages I need"
go get -u -v golang.org/x/tools/cmd/godoc

go get -u -v github.com/nsf/gocode
go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v github.com/golang/lint/golint
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v golang.org/x/tools/cmd/guru
go get -u -v golang.org/x/tools/cmd/gotype

go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/lukehoban/go-outline
go get -u -v github.com/tpng/gopkgs
go get -u -v github.com/newhook/go-symbols
go get -u -v github.com/cweill/gotests/...
