#!/bin/bash
set -e

cd ct-benchmarks


run_ct_fuzz()
{
  d=$1
  TL=$2
  TS=$3
  echo '------------------------------------------'
  echo $1 
  echo '------------------------------------------'
  #python ~/artifact/ct-benchmarks/scripts/run.py --time-limit $TL --exit-on-crash $d | grep -E 'Wall time elapsed|unique_crashes'
  for i in `seq 1 $TS`; do python ~/artifact/ct-benchmarks/scripts/run.py $d --time-limit=$TL --exit-on-crash; done | python ~/artifact/ct-benchmarks/scripts/analyze-result.py
}

make_bins()
{
  b=$1
  git checkout $b
  rm -rf ./poly1305-donna/build
  rm -rf ./openssl/build
  rm -rf ./BearSSL/build
  rm -rf ./s2n/build
  rm -rf ./wu-issta-2018/build
  rm -rf ./libsodium/build
  rm -rf ./poly1305-opt/build
  make > /dev/null 2>&1
}


run_ct()
{
echo '=========================================='
echo 'constant time' 
echo '=========================================='

run_ct_fuzz ./wu-issta-2018/build/appliedCryp 10 100
run_ct_fuzz ./wu-issta-2018/build/botan 10 100
run_ct_fuzz ./wu-issta-2018/build/chronos 10 100
run_ct_fuzz ./wu-issta-2018/build/Felics 10 100
run_ct_fuzz ./wu-issta-2018/build/libg 10 100
run_ct_fuzz ./wu-issta-2018/build/supercop 10 100
run_ct_fuzz ./BearSSL/build/aes_small_wrapper 10 100
run_ct_fuzz ./BearSSL/build/aes_ct_wrapper 100 2
run_ct_fuzz ./BearSSL/build/md5_wrapper 100 2
run_ct_fuzz ./libsodium/build 100 2
run_ct_fuzz ./openssl/build/EVP_aes_128_cbc_wrapper 10 100
run_ct_fuzz ./openssl/build/ssl3_cbc_copy_mac_modulo_wrapper 100 2
run_ct_fuzz ./openssl/build/ssl3_cbc_copy_mac_wrapper 100 2
run_ct_fuzz ./poly1305-donna/build 100 2
run_ct_fuzz ./poly1305-opt/build 100 2
run_ct_fuzz ./s2n/build 100 2
}

run_cm()
{
echo '=========================================='
echo 'cache model' 
echo '=========================================='

run_ct_fuzz ./wu-issta-2018/build/appliedCryp 10 100
run_ct_fuzz ./wu-issta-2018/build/botan 10 100
run_ct_fuzz ./wu-issta-2018/build/chronos 10 100
run_ct_fuzz ./wu-issta-2018/build/Felics 100 2
run_ct_fuzz ./wu-issta-2018/build/libg 10 100
run_ct_fuzz ./wu-issta-2018/build/supercop 10 100
run_ct_fuzz ./BearSSL/build/aes_small_wrapper 10 100
run_ct_fuzz ./BearSSL/build/aes_ct_wrapper 100 2
run_ct_fuzz ./BearSSL/build/md5_wrapper 100 2
run_ct_fuzz ./libsodium/build 100 2
run_ct_fuzz ./openssl/build/EVP_aes_128_cbc_wrapper 10 100
run_ct_fuzz ./openssl/build/ssl3_cbc_copy_mac_modulo_wrapper 100 2
run_ct_fuzz ./openssl/build/ssl3_cbc_copy_mac_wrapper 100 2
run_ct_fuzz ./poly1305-donna/build 100 2
run_ct_fuzz ./poly1305-opt/build 100 2
run_ct_fuzz ./s2n/build 100 2
}

make_bins master
run_ct
make_bins cm
run_cm

cd ..
