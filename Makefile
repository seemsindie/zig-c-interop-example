# Compiler settings
CC = gcc
ZIG = zig

# Directories
SRC_DIR = src
BUILD_DIR = build
BIN_DIR = bin
INCLUDE_DIR = include

# Flags
CFLAGS = -Wall -Wextra -std=c99 -I$(INCLUDE_DIR) -I$(SRC_DIR) -Os -ffunction-sections -fdata-sections
ZIGFLAGS = -OReleaseSmall

# Targets
all: $(BIN_DIR)/c_app $(BIN_DIR)/zig_app

# Create directories
$(BUILD_DIR) $(BIN_DIR):
	mkdir -p $@

# C application
$(BIN_DIR)/c_app: $(BUILD_DIR)/app.o $(BUILD_DIR)/lib_c.o $(BUILD_DIR)/lib.o | $(BIN_DIR)
	$(ZIG) cc $(ZIGFLAGS) $^ -o $@ -Wl,--gc-sections

$(BUILD_DIR)/app.o: $(SRC_DIR)/app.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lib_c.o: $(SRC_DIR)/lib.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lib.o: $(SRC_DIR)/lib.zig | $(BUILD_DIR)
	$(ZIG) build-obj $(ZIGFLAGS) $< -fPIC -femit-bin=$@

# Zig application
$(BIN_DIR)/zig_app: $(SRC_DIR)/app.zig $(SRC_DIR)/lib.c $(SRC_DIR)/lib.zig | $(BIN_DIR)
	$(ZIG) build-exe $(ZIGFLAGS) $< $(word 2,$^) -I$(INCLUDE_DIR) -I$(SRC_DIR) -femit-bin=$@

# Clean up
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

# Run targets
run-c: $(BIN_DIR)/c_app
	$<

run-zig: $(BIN_DIR)/zig_app
	$<

# Summary
summary: all
	@echo "Build Summary:"
	@echo "C app size: $$(du -h $(BIN_DIR)/c_app | cut -f1)"
	@echo "Zig app size: $$(du -h $(BIN_DIR)/zig_app | cut -f1)"

.PHONY: all clean run-c run-zig summary