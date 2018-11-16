export CC=ct-fuzz-afl-clang-fast
export CXX=ct-fuzz-afl-clang-fast
export ENABLE_CT_FUZZ=true
export AFL_DONT_OPTIMIZE=true
export AFL_PATH=$(dir $(shell which ct-fuzz-afl-clang-fast))/../lib/ct-fuzz
export CFLAGS=-Wl,-undefined,dynamic_lookup -g

ifeq ($(shell uname -s),Darwin)
  SO := dylib
else
  SO := so
endif

sources := $(wildcard specs/*.cpp)
objects := $(patsubst specs/%.cpp,build/%,$(sources))

all: $(objects)

#src/libbotan-2.so: src/Makefile
#	(cd src && make -j16 || true)
#
src/Makefile:
	(cd src && python configure.py --disable-aes-ni  --disable-ssse3 --with-debug-info --disable-static-library)

build/%: specs/%.cpp src/libbotan-2.so src/Makefile
	mkdir -p $(dir $@)
	ct-fuzz --entry-point $(patsubst %.cpp,%,$(notdir $<)) -o $@ $< \
	--seed-file $(patsubst %,%.seed,$@) \
	--compiler-options="-I$(abspath $(dir $(@D)))/src/build/include \
	-L$(abspath $(dir $(@D)))/src/ \
	-Wl,-rpath,$(abspath $(dir $(@D)))/src/ \
	-g -std=c++11 \
	-lbotan-2"
