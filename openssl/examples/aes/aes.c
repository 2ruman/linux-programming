/*
 * aes.c
 *
 *      Author: truman
 *
 */
#include <stdio.h>
#include <string.h>
#include <openssl/err.h>
#include <openssl/evp.h>
#include <openssl/rand.h>

#include "aes.h"

void gen_rand_bytes(unsigned char *bytes, int len) {
    IS_FAILED(RAND_bytes(bytes, len)) {
        memset(bytes, 0xFF, len);
    }
}

void *secure_memset(void *v, int c, size_t n) {
    volatile unsigned char *p = v;
    while (n--) *p++ = c;
    return v;
}

const EVP_CIPHER *get_op(int key_len) {
    switch(key_len)
    {
        case 16:
            return EVP_aes_128_gcm ();
        case 24:
            return EVP_aes_192_gcm ();
        case 32:
            return EVP_aes_256_gcm ();
        default:
            return NULL;
    }
}

void leave_a_trace(const char *err_msg) {
    AES_LOGE("%s\n", err_msg);
}

void handle_errors() {
    /* Choice #1,
     * Get the error code and print as human-readable message. */
    // char err_buf[256] = { 0 };
    // unsigned long err_code = ERR_get_error();
    // ERR_error_string_n(err_code, err_buf, 256);
    // AES_LOGE("Error(%lu) : %s\n", err_code, err_buf);

    /* Choice #2,
     * Convenience function to print all errors. */
    // ERR_print_errors_fp(stderr);

    /* Abort the process if needed. */
    // abort();
}

int aes_gcm_encrypt(unsigned char *plaintext, int plaintext_len,
            unsigned char *aad, int aad_len,
            unsigned char *key, int key_len,
            unsigned char *iv, int iv_len,
            unsigned char *ciphertext,
            unsigned char *tag, int tag_len)
{
    EVP_CIPHER_CTX *ctx;

    int updated_len;
    int ciphertext_len = -1;

    do {
        /* Initialize the cipher context */
        if (!(ctx = EVP_CIPHER_CTX_new())) {
            handle_errors();
            break;
        }

        /* Initialize the encryption operation */
        IS_FAILED(EVP_EncryptInit_ex(ctx, get_op(key_len), NULL, NULL, NULL)) {
            handle_errors();
            break;
        }

        /* Set the IV length(12 bytes by default) */
        IS_FAILED(EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL)) {
            handle_errors();
            break;
        }

        /* Initialize the key and IV */
        IS_FAILED(EVP_EncryptInit_ex(ctx, NULL, NULL, key, iv)) {
            handle_errors();
            break;
        }

        /* Provide the AAD,
         * Meanwhile it can be omitted or called multiple times. */
        IS_FAILED(EVP_EncryptUpdate(ctx, NULL, &updated_len, aad, aad_len)) {
            handle_errors();
            break;
        }
        AES_LOGD("updated_len : %d\n", updated_len);

        /* Provide the text to be encrypted, and obtain the cipher text,
         * Meanwhile it can be called multiple times if needed. */
        IS_FAILED(EVP_EncryptUpdate(ctx, ciphertext, &updated_len, plaintext, plaintext_len)) {
            handle_errors();
            break;
        }
        ciphertext_len = updated_len;
        AES_LOGD("updated_len : %d\n", updated_len);

        /* Finalize the encryption. Normally ciphertext may be written at this stage,
         * but this does not occur in GCM mode. Means the updated length would be zero. */
        IS_FAILED(EVP_EncryptFinal_ex(ctx, ciphertext + updated_len, &updated_len)) {
            handle_errors();
            break;
        }
        ciphertext_len += updated_len;
        AES_LOGD("updated_len : %d\n", updated_len);

        /* Get the authentication tag */
        IS_FAILED(EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, tag_len, tag)) {
            handle_errors();
            break;
        }
    } while(0);

    if (ctx) {
        /* Clean up */
        EVP_CIPHER_CTX_free(ctx);
    }
    return ciphertext_len;
}

int aes_gcm_decrypt(unsigned char *ciphertext, int ciphertext_len,
            unsigned char *aad, int aad_len,
            unsigned char *tag, int tag_len,
            unsigned char *key, int key_len,
            unsigned char *iv, int iv_len,
            unsigned char *plaintext)
{
    EVP_CIPHER_CTX *ctx;

    int updated_len;
    int plaintext_len = -1;

    do {
        /* Initialize the cipher context */
        if (!(ctx = EVP_CIPHER_CTX_new())) {
            handle_errors();
            break;
        }

        /* Initialize the decryption operation */
        IS_FAILED(EVP_DecryptInit_ex(ctx, get_op(key_len), NULL, NULL, NULL)) {
            handle_errors();
            break;
        }

        /* Set the IV length(12 bytes by default) */
        IS_FAILED(EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL)) {
            handle_errors();
            break;
        }

        /* Initialize the key and IV */
        IS_FAILED(EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv)) {
            handle_errors();
            break;
        }

        /* Provide the AAD,
         * Meanwhile it can be omitted or called multiple times. */
        IS_FAILED(EVP_DecryptUpdate(ctx, NULL, &updated_len, aad, aad_len)) {
            handle_errors();
            break;
        }
        AES_LOGD("updated_len : %d\n", updated_len);

        /* Provide the text to be decrypted, and obtain the plain text,
         * Meanwhile it can be called multiple times if needed. */
        IS_FAILED(EVP_DecryptUpdate(ctx, plaintext, &updated_len, ciphertext, ciphertext_len)) {
            handle_errors();
            break;
        }
        plaintext_len = updated_len;
        AES_LOGD("updated_len : %d\n", updated_len);

        /* Provide the authentication tag */
        IS_FAILED(EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, tag_len, tag)) {
            handle_errors();
            break;
        }

        /* Finalize the decryption. A positive return value indicates success,
         * otherwise failure. Means plaintext is not truthworthy. */
        if (EVP_DecryptFinal_ex(ctx, plaintext + updated_len, &updated_len) > 0) {
            plaintext_len += updated_len;
            AES_LOGD("updated_len : %d\n", updated_len);
        } else {
            plaintext_len = -1;
        }
    } while(0);

    if (ctx) {
        /* Clean up */
        EVP_CIPHER_CTX_free(ctx);
    }
    return plaintext_len;
}
