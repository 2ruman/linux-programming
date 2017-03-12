/*
 * sha.h
 *
 *      Author  : Truman
 *      Contact : truman.t.kim@gmail.com
 *      Version : 1.1.0
 *
 */

#ifndef SHA_H_
#define SHA_H_

#include <string.h>
#include <openssl/sha.h>

#define ALGO_SHA256 0
#define ALGO_SHA512 1

#define SHA512_OUT_LEN SHA512_DIGEST_LENGTH
#define SHA256_OUT_LEN SHA256_DIGEST_LENGTH

unsigned char *hash_msg(char *msg, unsigned char *out, int algo);
unsigned char *do_sha256(unsigned char *data, size_t size, unsigned char *out);
unsigned char *do_sha512(unsigned char *data, size_t size, unsigned char *out);

#endif /* SHA_H_ */
