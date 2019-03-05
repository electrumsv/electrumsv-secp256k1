#!/bin/bash

if [[ "$AGENT_OS" == "Linux" && ${BUILD_LINUX_WHEELS} -eq 1 ]]; then
    mkdir .hidden
    cp * .hidden -R
    mkdir .hidden/dist
    mv .hidden/electrumsv_secp256k1/_windows_libsecp256k1.py .hidden/electrumsv_secp256k1/_libsecp256k1.py
    mv .hidden ../clean
    sudo apt-get install -y mingw-w64
    sudo apt-get -f install
fi
