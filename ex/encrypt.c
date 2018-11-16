// encrypt.c
#include "ct-fuzz.h"
const char book[10] __attribute__((aligned(64)))
  = { 52, 48, 55, 51, 56, 54, 50, 49, 57, 53 };

void encrypt(char* msg, unsigned len) {
  for (unsigned i = 0; i < len; ++i)
    msg[i] = book[msg[i]-48];
}

// ct-fuzz specification

CT_FUZZ_SPEC(void, encrypt, char* msg, unsigned len) {
  __ct_fuzz_ptr_len(msg, len, 4);
  __ct_fuzz_public_in(len);

  for (unsigned i = 0; i < len; ++i)
    CT_FUZZ_ASSUME(msg[i]>=48 && msg[i]<=57);
}

CT_FUZZ_SEED(void, encrypt, char*, unsigned) {
  SEED_1D_ARR(char, msg, 4, {'1','2','3','4'})
  PRODUCE(encrypt, msg, 4);
}
