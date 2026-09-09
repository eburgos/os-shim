# os-shim project justfile
# Run `just --list` to see all available commands

# Default recipe - show help
default:
    @just --list

# Run code formatting
fmt:
    @echo "Formatting code..."
    cargo fmt --all

# Check code formatting without making changes
fmt-check:
    @echo "Checking code formatting..."
    cargo fmt --all -- --check

# Run linting with clippy (lint config lives in Cargo.toml [lints.clippy])
lint:
    @echo "Running clippy lints..."
    cargo clippy --all-targets --all-features

# Run all tests (every feature except the opt-in expensive ones)
test:
    @echo "Running tests..."
    cargo test --features zip,process

# Run tests across every feature combination that ships
test-features:
    @echo "Testing each feature combination..."
    cargo test --no-default-features
    cargo test --features process
    cargo test --features zip
    cargo test --features zip,process

# Run the opt-in expensive tests. Wants a disk-backed TMPDIR and double-digit
# gibibytes of headroom; takes minutes, not seconds.
test-slow:
    @echo "Running expensive tests..."
    cargo test --features zip,process,zip-large-file -- --nocapture

# Run tests with output
test-verbose:
    @echo "Running tests (verbose)..."
    cargo test --features zip,process -- --nocapture

# Generate code coverage report (requires cargo-llvm-cov)
test-coverage:
    @echo "Generating code coverage report..."
    cargo llvm-cov --workspace --features zip,process

# Generate code coverage HTML report (requires cargo-llvm-cov)
test-coverage-html:
    @echo "Generating code coverage HTML report..."
    cargo llvm-cov --workspace --features zip,process --html
    @echo "Coverage report generated in target/llvm-cov/html/"

# Build in debug mode
build:
    @echo "Building..."
    cargo build --all-features

# Build optimized release
build-release:
    @echo "Building release..."
    cargo build --release --all-features

# Check for security vulnerabilities
audit:
    @echo "Checking for security vulnerabilities..."
    cargo audit

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    cargo clean

# Generate documentation
docs:
    @echo "Generating documentation..."
    cargo doc --all-features --no-deps

# Full pipeline (standardized `all` entry point across tixena repos).
all: fmt-check lint test-features build
    @echo "All checks completed successfully!"
