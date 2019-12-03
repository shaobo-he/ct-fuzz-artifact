#!/bin/bash
set -e
set -x

# install llvm-3.9

sudo apt-get install gcc g++ build-essential clang-3.9 python cmake autoconf -y

sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.9 30
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.9 30
sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-3.9 30
sudo update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-3.9 30
sudo update-alternatives --install /usr/bin/llc llc /usr/bin/llc-3.9 30
sudo update-alternatives --install /usr/bin/opt opt /usr/bin/opt-3.9 30

# install lit
cd python-pkgs
(cd setuptools-40.5.0 && sudo python setup.py install)
(cd lit-0.7.0 && sudo python setup.py install)
(cd docutils-0.14 && sudo python setup.py install)
(cd statistics-1.0.3.5  && sudo python setup.py install)
cd ..

# install jemalloc
cd jemalloc
autoconf
./configure
make
sudo make install || true
cd ..

# copy files
cp fixes/openssl-1.1.0h.tar.gz ct-benchmarks/openssl
cp fixes/openssl-1.1.0h.tar.gz ct-benchmarks/s2n
cp fixes/libbotan-2.so.9 ct-benchmarks/botan/src
(cd ct-benchmarks/botan/src && ln -s libbotan-2.so.9 libbotan-2.so)
cp fixes/Makefile ct-benchmarks/botan

# install ct-fuzz
cd ct-fuzz
mkdir build && cd build
export CC=clang
export CXX=clang++
cmake .. && make
sudo make install
cd ..
