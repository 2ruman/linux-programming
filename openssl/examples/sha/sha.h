/*
 * sha.h
 *
 *      Author: truman
 *
 */

#ifndef SHA_H_
#define SHA_H_

#include <string.h>
#include <openssl/sha.h>

#define SHA512_OUT_LEN SHA512_DIGEST_LENGTH
#define SHA256_OUT_LEN SHA256_DIGEST_LENGTH

unsigned char *do_sha256(char *msg, unsigned char *out);
unsigned char *do_sha512(char *msg, unsigned char *out);

#endif /* SHA_H_ */
