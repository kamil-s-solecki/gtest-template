#!/bin/sh

GTEST_VERSION="1.11.0"

cd build/tests

wget "https://github.com/google/googletest/archive/refs/tags/release-${GTEST_VERSION}.tar.gz" -O gtest.tar.gz
tar xf gtest.tar.gz
mv googletest* gtest
cd gtest

# BUILDING GTEST
cmake -DBUILD_SHARED_LIBS=ON .
make

# COPYTING .h's AND .so's
mkdir -p ../gtest_include
cp -a googletest/include/gtest ../gtest_include
cp -a googlemock/include/gmock ../gtest_include
mkdir -p ../gtest_lib
cp -a lib/*so* ../gtest_lib
: '
# dereference links
cd lib
cp -L *.so ../../gtest_lib
cd ..
'

# cleanup
cd ..
rm -rf gtest
rm gtest.tar.gz