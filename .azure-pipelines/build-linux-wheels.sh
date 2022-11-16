#!/bin/bash

# rt12 -- This runs in docker, so has no access to anything out in the CI

set -e
set -x

# Install a system package required by our library
yum install -y libffi libffi-devel

# Use updated GMP
curl -O https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.bz2 && tar -xjpf gmp-*.tar.bz2 && cd gmp* && ./configure --build=${BUILD_GMP_CPU}-pc-linux-gnu > /dev/null && make > /dev/null && make check > /dev/null && make install > /dev/null && cd ..

mkdir out

# Compile wheels
for PYBIN in /opt/python/*/bin; do
	if [[ ${PYBIN} =~ (cp37|cp38|cp39|cp310|cp311) ]]; then
        echo Building for: ${PYBIN}
	    ${PYBIN}/pip wheel /io/ -w wheelhouse/
    fi
done

# Adjust wheel tags
for whl in wheelhouse/electrumsv_secp256k1*.whl; do
    auditwheel -v repair $whl -w out
done

cp out/*.whl /io/dist
