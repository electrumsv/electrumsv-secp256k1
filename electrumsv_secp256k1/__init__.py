import os

# pylint: disable=import-error
from ._libsecp256k1 import ffi, lib

# rt12 -- These constants are available on the library directly.

# SECP256K1_FLAGS_TYPE_MASK = ((1 << 8) - 1)
# SECP256K1_FLAGS_TYPE_CONTEXT = (1 << 0)
# SECP256K1_FLAGS_TYPE_COMPRESSION = (1 << 1)
# # /** The higher bits contain the actual data. Do not use directly. */
# SECP256K1_FLAGS_BIT_CONTEXT_VERIFY = (1 << 8)
# SECP256K1_FLAGS_BIT_CONTEXT_SIGN = (1 << 9)
# SECP256K1_FLAGS_BIT_COMPRESSION = (1 << 8)

# # /** Flags to pass to secp256k1_context_create. */
# SECP256K1_CONTEXT_VERIFY = (SECP256K1_FLAGS_TYPE_CONTEXT | SECP256K1_FLAGS_BIT_CONTEXT_VERIFY)
# SECP256K1_CONTEXT_SIGN = (SECP256K1_FLAGS_TYPE_CONTEXT | SECP256K1_FLAGS_BIT_CONTEXT_SIGN)
# SECP256K1_CONTEXT_NONE = (SECP256K1_FLAGS_TYPE_CONTEXT)

# SECP256K1_EC_COMPRESSED = (SECP256K1_FLAGS_TYPE_COMPRESSION | SECP256K1_FLAGS_BIT_COMPRESSION)
# SECP256K1_EC_UNCOMPRESSED = (SECP256K1_FLAGS_TYPE_COMPRESSION)

def create_context():
    ctx = ffi.gc(
            lib.secp256k1_context_create(lib.SECP256K1_CONTEXT_SIGN | lib.SECP256K1_CONTEXT_VERIFY),
            lib.secp256k1_context_destroy)
    r = lib.secp256k1_context_randomize(ctx, os.urandom(32))
    if r:
        return ctx
