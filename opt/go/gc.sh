GO=~/dev/opt/go

cd $GO
rm -rf $GO/go-darwin-amd64-bootstrap*

cd $GO/src/src
time GOROOT_BOOTSTRAP=~/dev/opt/go/goroot GOOS=darwin GOARCH=amd64 ./bootstrap.bash

if [ $? == 0 ]
then
    cd $GO
    rm -rf goroot.back
    mv goroot goroot.back
    mv go-darwin-amd64-bootstrap goroot
    rm -rf $GO/go-darwin-amd64-bootstrap*
fi
