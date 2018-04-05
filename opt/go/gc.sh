GO=~/dev/opt/go
OS=darwin
[ $(uname -s) == "Linux" ] && OS=linux

cd $GO
rm -rf $GO/go-$OS-amd64-bootstrap*

if [ "$1" == "master" ]
then
	cd $GO/src/

	git checkout master
	git branch -D release-branch.custom_master

	git fetch
	git reset --hard

	git checkout -b release-branch.custom_master

	echo go1.99.99 > VERSION
	git add VERSION
	git commit -am 'Fake Version'
	git tag -d go1.99.99
	git tag -am 'customer tag' go1.99.99
fi

cd $GO/src/src
time GOROOT_BOOTSTRAP=~/dev/opt/go/goroot GOOS=$OS GOARCH=amd64 ./bootstrap.bash

if [ $? == 0 ]
then
    cd $GO
    rm -rf goroot.back
    mv goroot goroot.back
    mv go-$OS-amd64-bootstrap goroot
    rm -rf $GO/go-$OS-amd64-bootstrap*
fi
