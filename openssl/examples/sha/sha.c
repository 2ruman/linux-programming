/*
 * sha.c
 *
 *      Author  : Truman
 *      Contact : truman.t.kim@gmail.com
 *      Version : 1.1.0
 */

#include "sha.h"

unsigned char *hash_msg(char *msg, unsigned char *out, int algo) {
    switch(algo) {
        case ALGO_SHA256:
            return do_sha256((unsigned char *)msg, strlen(msg), out);
        case ALGO_SHA512:
            return do_sha512((unsigned char *)msg, strlen(msg), out);
    }
    return 0;
}

unsigned char *do_sha256(unsigned char *data, size_t size, unsigned char *out) {
    return SHA256((const unsigned char *)data, size, out);
}

unsigned char *do_sha512(unsigned char *data, size_t size, unsigned char *out) {
    return SHA512((const unsigned char *)data, size, out);
}

