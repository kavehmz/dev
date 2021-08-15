GO=~/dev/opt/go

if [ ! -f $GOROOT/bin/go ]
then
	mkdir -p ~/dev/opt/tmpdl
	curl -L  https://golang.org/dl/go1.16.7.darwin-arm64.tar.gz|tar -xz -C ~/dev/opt/tmpdl/
	mv ~/dev/opt/tmpdl/go $GOROOT
fi

OS=darwin

cd $GO
rm -rf $GO/go-$OS-arm64-bootstrap*

cd $GO/src/src
time GOROOT_BOOTSTRAP=~/dev/opt/go/goroot GOOS=$OS GOARCH=arm64 ./bootstrap.bash

if [ $? == 0 ]
then
    cd $GO
    rm -rf goroot.back
    mv goroot goroot.back
    mv go-$OS-arm64-bootstrap goroot
    rm -rf $GO/go-$OS-arm64-bootstrap*
fi
