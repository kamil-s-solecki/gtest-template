TESTS_DIR := ./tests
BUILD_DIR := ./build

# > TESTS CONFIG
TESTS_BUILD_DIR := $(BUILD_DIR)/tests
GLIB_SO_DIR := $(TESTS_BUILD_DIR)/gtest_lib
GLIB_SO_FILE := $(GLIB_SO_DIR)/libgtest.so

TESTS_SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')
TESTS_OBJS := $(TESTS_SRCS:%=$(TESTS_BUILD_DIR)/%.o)

TESTS_EXEC := test

TESTS_INCS := -I$(TESTS_BUILD_DIR)/gtest_include
TESTS_LDFLAGS := -L$(GLIB_SO_DIR) -lgtest

TESTS_EXEC := run_tests
# < TESTS CONFIG

.PHONY: test
test: $(TESTS_BUILD_DIR)/$(TESTS_EXEC)
	@echo ">> RUNNING TESTS"
	LD_LIBRARY_PATH=$(GLIB_SO_DIR) ./$(TESTS_BUILD_DIR)/$(TESTS_EXEC)

# Linking C++ test source
$(TESTS_BUILD_DIR)/$(TESTS_EXEC): $(TESTS_OBJS)
	@echo ">> LINK"
	$(CXX) $(TESTS_OBJS) -o $@ $(LDFLAGS) $(TESTS_LDFLAGS)

# Build step for C++ test source
$(TESTS_BUILD_DIR)/%.cpp.o: %.cpp $(GLIB_SO_FILE)
	@echo ">> COMPILE"
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(TESTS_INCS) -c $< -o $@

# Build gtest library
$(GLIB_SO_FILE):
	@echo ">> BUILD GTEST"
	mkdir -p build/tests
	build_scripts/build_gtest.sh

clean:
	rm -rf build