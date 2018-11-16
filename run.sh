#!/bin/bash
set -e

cd ct-benchmarks

TL=$1

run_ct_fuzz()
{
  d=$1
  echo '------------------------------------------'
  echo $1 
  echo '------------------------------------------'
  python ~/artifact/ct-benchmarks/scripts/run.py --time-limit $TL --exit-on-crash $d | grep -E 'Wall time elapsed|unique_crashes'
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


run_bins()
{
echo '=========================================='
echo $1
echo '=========================================='

run_ct_fuzz ./wu-issta-2018/build/appliedCryp
run_ct_fuzz ./wu-issta-2018/build/botan
run_ct_fuzz ./wu-issta-2018/build/chronos
run_ct_fuzz ./wu-issta-2018/build/Felics
run_ct_fuzz ./wu-issta-2018/build/libg
run_ct_fuzz ./wu-issta-2018/build/supercop
run_ct_fuzz ./BearSSL/build
run_ct_fuzz ./libsodium/build
run_ct_fuzz ./openssl/build
run_ct_fuzz ./poly1305-donna/build
run_ct_fuzz ./poly1305-opt/build
run_ct_fuzz ./s2n/build
}

make_bins master
run_bins constant-time
make_bins cm
run_bins cache-model

cd ..
