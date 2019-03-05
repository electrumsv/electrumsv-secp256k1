import os
import shutil
from contextlib import contextmanager
from tempfile import mkdtemp

import subprocess


@contextmanager
def workdir():
    cwd = os.getcwd()
    tmpdir = mkdtemp()
    os.chdir(tmpdir)
    try:
        yield
    finally:
        os.chdir(cwd)
        shutil.rmtree(tmpdir)


@contextmanager
def redirect(stdchannel, dest_filename):
    oldstdchannel = os.dup(stdchannel.fileno())
    dest_file = open(dest_filename, 'w')
    os.dup2(dest_file.fileno(), stdchannel.fileno())
    try:
        yield
    finally:
        if oldstdchannel is not None:
            os.dup2(oldstdchannel, stdchannel.fileno())
        if dest_file is not None:
            dest_file.close()


def absolute(*paths):
    op = os.path
    return op.realpath(op.abspath(op.join(op.dirname(__file__), *paths)))


def build_flags(library, type_, path):
    """Return separated build flags from pkg-config output"""

    pkg_config_path = [path]
    if "PKG_CONFIG_PATH" in os.environ:
        pkg_config_path.append(os.environ['PKG_CONFIG_PATH'])
    if "LIB_DIR" in os.environ:
        pkg_config_path.append(os.environ['LIB_DIR'])
        pkg_config_path.append(os.path.join(os.environ['LIB_DIR'], "pkgconfig"))

    options = ["--static", {'I': "--cflags-only-I", 'L': "--libs-only-L", 'l': "--libs-only-l"}[type_]]

    return [
        flag.strip("-{}".format(type_))
        for flag in subprocess.check_output(
            ["pkg-config"] + options + [library], env=dict(os.environ, PKG_CONFIG_PATH=":".join(pkg_config_path))
        )
        .decode("UTF-8")
        .split()
    ]

def detect_dll():
    here = os.path.dirname(os.path.abspath(__file__))
    for fn in os.listdir(os.path.join(here, 'electrumsv_secp256k1')):
        if fn.endswith('.dll'):
            return True
    return False
