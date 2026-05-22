.PHONY: all build check clippy fmt fmt-check clean run deploy install help

# ── Config ────────────────────────────────────────────────────────────────────
PACKAGE   := cambridge-dictionary-scraper
BIN_NAME  := cam
CARGO     := cargo
INSTALL_DIR := $(HOME)/.local/bin

# ── Debug flag (default: y) ───────────────────────────────────────────────────
debug     ?= y

ifeq ($(debug), y)
  BUILD_FLAGS :=
  BIN         := target/debug/$(BIN_NAME)
  BUILD_MODE  := debug
else
  BUILD_FLAGS := --release
  BIN         := target/release/$(BIN_NAME)
  BUILD_MODE  := release
endif

# ── Default ───────────────────────────────────────────────────────────────────
all: build

# ── Build ─────────────────────────────────────────────────────────────────────
build:
	@echo "› Building ($(BUILD_MODE))…"
	$(CARGO) build --package $(PACKAGE) $(BUILD_FLAGS)

# ── Quality ───────────────────────────────────────────────────────────────────
check:
	$(CARGO) check --package $(PACKAGE)

clippy:
	$(CARGO) clippy --package $(PACKAGE) -- -D warnings

format:
	$(CARGO) fmt --package $(PACKAGE)

format-check:
	$(CARGO) fmt --package $(PACKAGE) -- --check

# ── Run ───────────────────────────────────────────────────────────────────────
run: build
	@echo "› Running ($(BUILD_MODE))…"
	./$(BIN)

# ── Deploy & Install ──────────────────────────────────────────────────────────
deploy:
	@echo "› Building release…"
	$(CARGO) build --package $(PACKAGE) --release

install: deploy
	@echo "› Installing $(BIN_NAME) to $(INSTALL_DIR)…"
	@mkdir -p $(INSTALL_DIR)
	cp target/release/$(BIN_NAME) $(INSTALL_DIR)/$(BIN_NAME)
	@echo "✓ Installed to $(INSTALL_DIR)/$(BIN_NAME)"
	@echo "  Make sure $(INSTALL_DIR) is in your PATH"

# ── Clean ─────────────────────────────────────────────────────────────────────
clean:
	$(CARGO) clean

# ── Help ──────────────────────────────────────────────────────────────────────
help:
	@echo "Usage: make <target> [debug=y|n]"
	@echo ""
	@echo "  debug=y (default)  Debug build   → ./target/debug/cam"
	@echo "  debug=n            Release build → ./target/release/cam"
	@echo ""
	@echo "  build          Build the package"
	@echo "  check          Fast type-check (no codegen)"
	@echo "  clippy         Lint with Clippy (warnings as errors)"
	@echo "  format         Auto-format with rustfmt"
	@echo "  format-check   Check formatting without modifying files"
	@echo "  run            Build and run"
	@echo "  deploy         Build optimised release binary"
	@echo "  install        Deploy + copy binary to $(INSTALL_DIR)"
	@echo "  clean          Remove build artefacts"
