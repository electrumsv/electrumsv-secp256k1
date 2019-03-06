#!/bin/bash

set -e -x

build_dll() {
    ./autogen.sh
    echo "LDFLAGS = -no-undefined" >> Makefile.am
    ./configure --host=$1 --enable-module-recovery --enable-experimental --enable-module-ecdh --enable-endomorphism --disable-jni
    make
}

# Step up above the git repo checkout directory.
pushd ..
git clone https://github.com/electrumsv/secp256k1

if [[ "${LINUX_TARGET}" == "win32" ]]; then
    cd secp256k1
    # Keep synchronised with 'setup.py' located commit used by Linux/MacOS.
    git checkout 314a61d72474aa29ff4afba8472553ad91d88e9d
    build_dll i686-w64-mingw32
    mv .libs/libsecp256k1-0.dll ../clean/electrumsv_secp256k1/libsecp256k1.dll
    cd ../clean
    python setup.py bdist_wheel --universal --plat-name=win32
elif [[ "${LINUX_TARGET}" == "win64" ]]; then
    cd secp256k1
    # Keep synchronised with 'setup.py' located commit used by Linux/MacOS.
    git checkout 314a61d72474aa29ff4afba8472553ad91d88e9d
    build_dll x86_64-w64-mingw32
    mv .libs/libsecp256k1-0.dll ../clean/electrumsv_secp256k1/libsecp256k1.dll
    cd ../clean
    python setup.py bdist_wheel --universal --plat-name=win_amd64
fi

mv dist/* $BUILD_SOURCESDIRECTORY/dist/
popd
