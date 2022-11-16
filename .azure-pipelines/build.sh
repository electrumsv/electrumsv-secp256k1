#!/bin/bash

set -e -x

echo "deploy BUILD_SOURCESDIRECTORY=$BUILD_SOURCESDIRECTORY"

python setup.py install

# remove any left over files from previous steps
rm -rf build dist
mkdir dist

if [[ "$AGENT_OS" == "Linux" ]]; then
    if [[ "${LINUX_TARGET}" == "source" ]]; then
        python setup.py sdist
    elif [[ "${LINUX_TARGET}" == "linux64" ]]; then
        docker run --rm -e BUILD_GMP_CPU="amd64"  -v $(pwd):/io quay.io/pypa/manylinux2014_x86_64 /io/.azure-pipelines/build-linux-wheels.sh
    elif [[ "${LINUX_TARGET}" == "win64" ]]; then
        .azure-pipelines/build_windows_wheels.sh
    fi
elif [[ "$AGENT_OS" == "Darwin" ]]; then
    for AZPYPATH in $AZPY311_PYTHONLOCATION $AZPY310_PYTHONLOCATION $AZPY39_PYTHONLOCATION $AZPY38_PYTHONLOCATION $AZPY37_PYTHONLOCATION; do
        # Make sure we can build and "fix" the wheel.
        $AZPYPATH/python -m pip install delocate wheel
        # Create directories for the built and fixed wheels.
        mkdir dist_wheels/ fixed_wheels/
        # Build the wheel for the local OS.
        $AZPYPATH/python -m pip wheel . --wheel-dir dist_wheels/
        # Make the wheel relocatable to another OS.
        $AZPYPATH/bin/delocate-wheel \
            --check-archs \
            --wheel-dir fixed_wheels/ \
            --verbose \
            dist_wheels/electrumsv_secp256k1*.whl
        # Move the fixed wheel into dist/.
        [ -d dist/ ] || mkdir dist/
        mv fixed_wheels/electrumsv_secp256k1*.whl dist/
        # Clean up build directories.
        rm -fr dist_wheels/ fixed_wheels/
    done
fi

echo post deploy dist
ls -l dist

# rt12: not currently setup

# python -m pip install twine
# Ignore non-existing files in globs
# shopt -s nullglob
# twine upload --skip-existing dist/electrumsv_secp256k1*.{whl,gz} -u "${PYPI_USERNAME}"

set +e +x
