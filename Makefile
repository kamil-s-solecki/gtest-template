TESTS_DIR := ./tests
SRC_DIR := ./src
BUILD_DIR := ./build

# > SRC CONFIG
SRC_BUILD_DIR := $(BUILD_DIR)/src

SRC_SRCS := $(shell find $(SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
SRC_OBJS := $(SRC_SRCS:%=$(SRC_BUILD_DIR)/%.o)

SRC_INCS := -I$(SRC_DIR)/includes

TARGET_EXEC := run
# < SRC CONFIG

# > TESTS CONFIG
TESTS_BUILD_DIR := $(BUILD_DIR)/tests
GLIB_SO_DIR := $(TESTS_BUILD_DIR)/gtest_lib
GLIB_SO_FILE := $(GLIB_SO_DIR)/libgtest.so

MAIN_PATTERN := main(
SRC_WITHOUT_MAIN_SRCS := $(shell find $(SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s' | xargs grep -riLs ' $(MAIN_PATTERN)')
SRC_WITHOUT_MAIN_OBJS := $(SRC_WITHOUT_MAIN_SRCS:%=$(SRC_BUILD_DIR)/%.o)
TESTS_SRCS := $(shell find $(TESTS_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
TESTS_OBJS := $(TESTS_SRCS:%=$(TESTS_BUILD_DIR)/%.o)

TESTS_INCS := -I$(TESTS_BUILD_DIR)/gtest_include
TESTS_LDFLAGS := -L$(GLIB_SO_DIR) -lgtest

TESTS_EXEC := run_tests
# < TESTS CONFIG

.PHONY: build
build: $(BUILD_DIR)/$(TARGET_EXEC)
	@echo ">> BUILD DONE"

.PHONY: run
run: $(BUILD_DIR)/$(TARGET_EXEC)
	$(BUILD_DIR)/$(TARGET_EXEC)
	

# > TEST BUILD

.PHONY: test
test: $(BUILD_DIR)/$(TESTS_EXEC)
	@echo ">> RUNNING TESTS"
	LD_LIBRARY_PATH=$(GLIB_SO_DIR) ./$(BUILD_DIR)/$(TESTS_EXEC)

# Linking C++ test source
$(BUILD_DIR)/$(TESTS_EXEC): $(TESTS_OBJS) $(SRC_OBJS)
	@echo ">> LINK TESTS"
	$(CXX) $(TESTS_OBJS) $(SRC_WITHOUT_MAIN_OBJS) -o $@ $(LDFLAGS) $(TESTS_LDFLAGS)

# Build step for C++ test source
$(TESTS_BUILD_DIR)/%.cpp.o: %.cpp $(GLIB_SO_FILE)
	@echo ">> COMPILE TESTS"
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(TESTS_INCS) $(SRC_INCS) -c $< -o $@

# Build gtest library
$(GLIB_SO_FILE):
	@echo ">> BUILD GTEST"
	mkdir -p build/tests
	build_scripts/build_gtest.sh

# < TEST BUILD

# > SRC BUILD

# Linking C++ test source
$(BUILD_DIR)/$(TARGET_EXEC): $(SRC_OBJS)
	@echo ">> LINK SRC"
	$(CXX) $(SRC_OBJS) -o $@ $(LDFLAGS)

# Build step for C++ test source
$(SRC_BUILD_DIR)/%.cpp.o: %.cpp
	@echo ">> COMPILE SRC"
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(SRC_INCS) -c $< -o $@

# < SRC BUILD

clean:
	rm -rf build