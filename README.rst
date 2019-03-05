electrumsv-secp256k1
====================

Badges went here..

-----

This library provides a wrapped pre-compiled
`libsecp256k1 <https://github.com/bitcoin-core/secp256k1>`_, the heavily
optimized C library used by `Bitcoin Core <https://github.com/bitcoin/bitcoin>`_
for operations on elliptic curve secp256k1. It effectively encapsulates a libsecp256k1 fork
and allows ElectrumSV developers to have a vetted build, with selected public modifications,
available on pypi to treat as a first classed dependency which can be obtained and verified
against a known hash, like any other Python dependency.

Table of Contents
~~~~~~~~~~~~~~~~~

.. contents::
    :backlinks: top
    :local:

Features
--------

- Linux, macOS, and Windows all have binary packages for both 64 and 32-bit architectures
- Linux & macOS use GMP for faster computation
- Implements a fix for `<https://bugs.python.org/issue28150>`_ to support Python 3.6+ on macOS

Installation
------------

electrumsv-secp256k1 is distributed on PyPI and is available on Linux/macOS and Windows and
supports Python 3.6 and Python 3.7.

.. code-block:: bash

    $ pip install electrumsv-secp256k1

If you are on a system that doesn't have a precompiled binary wheel (e.g. FreeBSD)
then pip will fetch source to build yourself. You must have the necessary packages.

On Debian/Ubuntu for example the necessary packages are:

- build-essential
- automake
- pkg-config
- libtool
- libgmp-dev (optional)

API
---

Anything importing this should be familiar with the underlying libsecp256k1 api.

Credits
-------

- Contributors of `coincurve <https://github.com/ofek/coincurve>`_.
- Contributors of `libsecp256k1 <https://github.com/bitcoin-core/secp256k1>`_.
- Contributors of `secp256k1-py <https://github.com/ludbb/secp256k1-py>`_.
  While Coincurve is nearly a complete rewrite, much of the build system
  provided by `ulope <https://github.com/ulope>`_ remains.

History
-------

Coincurve history `available here <https://github.com/ofek/coincurve/blob/master/HISTORY.rst>`_.
