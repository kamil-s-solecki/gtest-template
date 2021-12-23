BUILD_DIR=./build
GLIB_SO_FILE=$(BUILD_DIR)/test/gtest_lib/libgtest.so

$(GLIB_SO_FILE):
	mkdir -p build/test
	build_scripts/build_gtest.sh

clean:
	rm -rf build