/*
 * main.c
 *
 *      Author: truman
 *
 */
#include <stdio.h>
#include <string.h>
#include "aes.h"

#define GIVEN_KEY_LEN 32
#define GIVEN_IV_LEN  16
#define GIVEN_TAG_LEN 16

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

int main() {

    unsigned char key[GIVEN_KEY_LEN] = {
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    };
    unsigned char iv[GIVEN_IV_LEN] = {
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };
    unsigned char tag[GIVEN_TAG_LEN] = {
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };
    unsigned char *aad       = (unsigned char *)"Here we go again";
    unsigned char *plaintext = (unsigned char *)"This is an example for AES-GCM.";

    int key_len       = GIVEN_KEY_LEN;
    int iv_len        = GIVEN_IV_LEN;
    int tag_len       = GIVEN_TAG_LEN;
    int aad_len       = strlen(aad);
    int plaintext_len = strlen(plaintext);

    unsigned char ciphertext[32] = { 0 };
    unsigned char final[32]      = { 0 };
    gen_rand_bytes(iv, iv_len);
    int ret;
    int ciphertext_len;

    printf("[ Encryption ]\n");
    ret = aes_gcm_encrypt(plaintext, plaintext_len,
                          aad, aad_len,
                          key, key_len,
                          iv, iv_len,
                          ciphertext,
                          tag, tag_len);

    printf("encrypted len : %d\n", ret);
    ciphertext_len = ret;

    printf("[ Decryption ]\n");
    ret = aes_gcm_decrypt(ciphertext, ciphertext_len,
                          aad, aad_len,
                          tag, tag_len,
                          key, key_len,
                          iv, iv_len,
                          final);

    printf("decrypted len : %d\n\n", ret);

    printf("Plain text : %s\n", plaintext);
    printf("Final      : %s\n", final);
    return 0;
}
