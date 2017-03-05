/*
 * main.c
 *
 *      Author: truman
 *
 */

#include <stdio.h>
#include "sha.h"

void print_hex(const char *tag, unsigned char *bytes, int len);

int main() {
    char *msg = "Hello. Here's the simplest example for SHA(Secure Hash Algorithm)."; /* The message to be hashed */

    unsigned char hash_256[SHA256_OUT_LEN] = { 0 }; /* The output length must be 256 bits, 32 in bytes */
    unsigned char hash_512[SHA512_OUT_LEN] = { 0 }; /* The output length must be 512 bits, 64 in bytes */

    unsigned char *out;

    printf("Message : %s\n", msg);

    /* At the moment, out must indicate hash_256 */
    out = do_sha256(msg, hash_256);
    print_hex("SHA256", out, SHA256_OUT_LEN);

    /* At the moment, out must indicate hash_512 */
    out = do_sha512(msg, hash_512);
    print_hex("SHA512", out, SHA512_OUT_LEN);
    return 0;
}

/**
 * Utils
 */
void print_hex(const char *tag, unsigned char *bytes, int len) {
    const char *HEX = "0123456789ABCDEF";
    char buff[1024] = { 0 };
    char *pBuff = buff;

    if (len <= 0 || (1024 / 3) < len) return;

    for (int i = 0 ; i < len ; i++) {
        *(pBuff++) = HEX[(bytes[i] >> 4) & 0x0F];
        *(pBuff++) = HEX[(bytes[i] & 0x0F)];
        *(pBuff++) = ' ';
    }
    printf("HEX(%s) : %s\n", (tag == NULL) ? "..." : tag, buff);
}

