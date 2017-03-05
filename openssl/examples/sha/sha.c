/*
 * sha.c
 *
 *      Author: truman
 *
 */

#include "sha.h"

unsigned char *do_sha256(char *msg, unsigned char *out) {
    return SHA256((const unsigned char *)msg, strlen(msg), out);
}

unsigned char *do_sha512(char *msg, unsigned char *out) {
    return SHA512((const unsigned char *)msg, strlen(msg), out);
}


