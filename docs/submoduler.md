# Submoduler - Git Submodule Configuration Tool

A Ruby tool for validating git submodule configuration in monorepo structures.

## Features

- **Submodule Configuration Check**: Verifies that `.gitmodules` file exists and is properly formatted
- **Path Validation**: Ensures that configured paths exist in the filesystem
- **Initialization Check**: Confirms that submodule directories are properly initialized with git

## Installation

No installation required. The tool is a standalone Ruby script.

## Usage

### Basic Usage

```bash
# Run validation report
ruby bin/submoduler.rb report

# Show help
ruby bin/submoduler.rb --help
```

### Example Output

```
Submodule Configuration Report
Generated: 2025-11-13 12:19:02
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Submodule Configuration Check
  ✓ Found .gitmodules file
  ✓ Parsed 4 submodule entries

📁 Path Validation
  ✗ core_gem/core
    Directory not found: core_gem/core
  ✓ example_apps/heartbeat_ar2ar

🔧 Initialization Check
  ✗ core_gem/core
    Cannot check initialization: directory does not exist
  ✓ example_apps/heartbeat_ar2ar

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary: 2 passed, 2 failed
```

## Exit Codes

- `0` - All checks passed or no submodules configured
- `1` - One or more validation checks failed
- `2` - Script error (not a git repo, invalid arguments, etc.)

## Requirements

- Ruby 2.7 or higher
- Git repository

## Testing

Run the test suite:

```bash
# Run all tests
ruby -Ilib:test -e 'Dir.glob("test/**/*test*.rb").each { |f| require_relative f }'

# Run specific test file
ruby -Ilib:test test/submoduler/test_git_modules_parser.rb
```

## Architecture

The tool uses a modular architecture with the following components:

- **SubmoduleEntry**: Data model for parsed submodule configuration
- **ValidationResult**: Data model for validation check outcomes
- **GitModulesParser**: Parses `.gitmodules` file
- **PathValidator**: Validates that paths exist and are correct
- **InitValidator**: Validates that submodules are initialized
- **ReportFormatter**: Formats validation results for console output
- **ReportCommand**: Orchestrates validation checks
- **CLI**: Command line interface entry point

## Development

The codebase follows these principles:

- Modular design with single responsibility classes
- Comprehensive test coverage (35 tests, 151 assertions)
- Clear error messages with actionable suggestions
- ANSI color-coded output for better readability

## License

Part of the ActiveDataFlow project.
