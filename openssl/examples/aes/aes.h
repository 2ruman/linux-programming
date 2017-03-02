/*
 * aes.h
 *
 * Author: truman
 *
 */
#ifndef AES_H_
#define AES_H_

#define SUCCESS  1
#define ERROR   -1

#define IS_FAILED(x)  if (1 != (x))
#define AES_LOGD(...) printf(__VA_ARGS__);
#define AES_LOGE(...) printf(__VA_ARGS__);

#define DEFAULT_IV_LEN

void gen_rand_bytes(unsigned char *bytes, int len);
void *secure_memset(void *v, int c, size_t n);

int aes_gcm_encrypt(unsigned char *plaintext, int plaintext_len,
            unsigned char *aad, int aad_len,
            unsigned char *key, int key_len,
            unsigned char *iv, int iv_len,
            unsigned char *ciphertext,
            unsigned char *tag, int tag_len);

int aes_gcm_decrypt(unsigned char *ciphertext, int ciphertext_len,
            unsigned char *aad, int aad_len,
            unsigned char *tag, int tag_len,
            unsigned char *key, int key_len,
            unsigned char *iv, int iv_len,
            unsigned char *plaintext);
#endif /* AES_H_ */
