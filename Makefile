.PHONY: all build check clippy fmt fmt-check clean run help

PACKAGE   := cambridge-dictionary-scraper
BIN_NAME  := cam
CARGO     := cargo

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

all: build

build:
	@echo "› Building ($(BUILD_MODE))…"
	$(CARGO) build --package $(PACKAGE) $(BUILD_FLAGS)

check:
	$(CARGO) check --package $(PACKAGE)

clippy:
	$(CARGO) clippy --package $(PACKAGE) -- -D warnings

format:
	$(CARGO) fmt --package $(PACKAGE)

format-check:
	$(CARGO) fmt --package $(PACKAGE) -- --check

run: build
	@echo "› Running ($(BUILD_MODE))…"
	./$(BIN)

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
	@echo "  fmt            Auto-format with rustfmt"
	@echo "  fmt-check      Check formatting without modifying files"
	@echo "  test           Run tests"
	@echo "  test-verbose   Run tests with stdout"
	@echo "  run            Build and run"
	@echo "  clean          Remove build artefacts"debug ?= y

ifeq ($(debug), y)
  BUILD_FLAGS :=
  BIN := target/debug/$(PACKAGE)
else
  BUILD_FLAGS := --release
  BIN := target/release/$(PACKAGE)
endif



