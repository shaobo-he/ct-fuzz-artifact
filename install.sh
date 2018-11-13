#!/bin/bash
set -e
set -x

# install llvm-3.9
cd debs
sudo dpkg -i libllvm3.9_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i llvm-3.9-runtime_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i llvm-3.9_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i llvm-3.9-dev_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i libclang1-3.9_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i libclang-common-3.9-dev_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i clang-3.9_1%3a3.9.1-19ubuntu1_amd64.deb
sudo dpkg -i libsigsegv2_2.12-1_amd64.deb
sudo dpkg -i m4_1.4.18-1_amd64.deb
sudo dpkg -i autoconf_2.69-11_all.deb
cd ..

sudo apt autoremove clang-6.0 -y

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
cd ..

# install jemalloc
cd jemalloc
./configure
make
sudo make install || true
cd ..

# install ct-fuzz
cd ct-fuzz
mkdir build && cd build
export CC=clang
export CXX=clang++
cmake .. && make
sudo make install
cd ..
