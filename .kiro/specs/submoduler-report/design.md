# Design Document: Submoduler Report Command

## Overview

The `submoduler.rb` script provides a `report` command that validates git submodule configuration in a repository. The tool performs three main validation checks:

1. **Submodule Configuration Check**: Verifies that submodules are defined in `.gitmodules`
2. **Path Validation**: Ensures that paths in `.gitmodules` match actual directory locations
3. **Initialization Check**: Confirms that submodule directories are properly initialized with git

The design uses a modular architecture with separate validator classes for each check type, coordinated by a report generator that produces formatted output.

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    SubmodulerCLI                        │
│  - Parses command line arguments                        │
│  - Routes to appropriate command handler                │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  ReportCommand                          │
│  - Orchestrates validation checks                       │
│  - Generates formatted report output                    │
└────────┬────────────────────────────────────────────────┘
         │
         ├──────────────┬──────────────┬─────────────────┐
         ▼              ▼              ▼                 ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│GitModules    │ │PathValidator │ │InitValidator │ │ReportFormatter│
│Parser        │ │              │ │              │ │              │
│              │ │              │ │              │ │              │
│- Reads       │ │- Checks path │ │- Checks .git │ │- Formats     │
│  .gitmodules │ │  existence   │ │  presence    │ │  output      │
│- Parses      │ │- Validates   │ │- Checks      │ │- Colors      │
│  entries     │ │  structure   │ │  empty dirs  │ │- Summaries   │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
```

## Components and Interfaces

### 1. SubmodulerCLI

**Responsibility**: Command line interface entry point

**Interface**:
```ruby
class SubmodulerCLI
  def self.run(args)
    # Parse arguments and route to command
  end
  
  private
  
  def self.parse_command(args)
    # Extract command and options
  end
  
  def self.show_usage
    # Display help text
  end
end
```

**Behavior**:
- Validates that script is run from a git repository
- Parses command line arguments
- Routes to `ReportCommand` when `report` is specified
- Displays usage information for invalid commands
- Returns appropriate exit codes

### 2. GitModulesParser

**Responsibility**: Parse and extract submodule configuration from `.gitmodules`

**Interface**:
```ruby
class GitModulesParser
  def initialize(repo_root)
    @repo_root = repo_root
    @gitmodules_path = File.join(repo_root, '.gitmodules')
  end
  
  def parse
    # Returns array of SubmoduleEntry objects
  end
  
  def exists?
    # Check if .gitmodules file exists
  end
end

class SubmoduleEntry
  attr_reader :name, :path, :url
  
  def initialize(name:, path:, url:)
    @name = name
    @path = path
    @url = url
  end
end
```

**Behavior**:
- Reads `.gitmodules` file using standard Ruby File I/O
- Parses INI-style format to extract submodule entries
- Returns structured data as `SubmoduleEntry` objects
- Handles malformed files gracefully with error messages

**Parsing Strategy**:
- Use simple regex patterns to match `[submodule "name"]` sections
- Extract `path` and `url` key-value pairs
- Build array of SubmoduleEntry objects

### 3. PathValidator

**Responsibility**: Validate that configured paths exist and are correct

**Interface**:
```ruby
class PathValidator
  def initialize(repo_root, submodule_entries)
    @repo_root = repo_root
    @entries = submodule_entries
  end
  
  def validate
    # Returns array of ValidationResult objects
  end
  
  private
  
  def check_path_exists(path)
    # Verify directory exists
  end
  
  def check_path_is_relative(path)
    # Ensure path is relative
  end
end

class ValidationResult
  attr_reader :submodule_name, :check_type, :status, :message
  
  def initialize(submodule_name:, check_type:, status:, message: nil)
    @submodule_name = submodule_name
    @check_type = check_type
    @status = status  # :pass or :fail
    @message = message
  end
  
  def passed?
    @status == :pass
  end
end
```

**Behavior**:
- For each submodule entry, check if the configured path exists
- Verify paths are relative (not absolute)
- Return validation results with pass/fail status
- Include helpful messages for failures (e.g., "Directory not found: core_gem/core")

### 4. InitValidator

**Responsibility**: Validate that submodule directories are properly initialized

**Interface**:
```ruby
class InitValidator
  def initialize(repo_root, submodule_entries)
    @repo_root = repo_root
    @entries = submodule_entries
  end
  
  def validate
    # Returns array of ValidationResult objects
  end
  
  private
  
  def check_git_present(path)
    # Check for .git file or directory
  end
  
  def check_directory_empty(path)
    # Check if directory has content
  end
end
```

**Behavior**:
- Check if submodule directory contains `.git` (file or directory)
- Check if directory is empty (not checked out)
- Return validation results for each submodule
- Distinguish between "not initialized" and "not checked out"

### 5. ReportCommand

**Responsibility**: Orchestrate validation and generate report

**Interface**:
```ruby
class ReportCommand
  def initialize(repo_root)
    @repo_root = repo_root
  end
  
  def execute
    # Run all validations and generate report
    # Returns exit code (0 for success, 1 for failures)
  end
  
  private
  
  def run_validations
    # Execute all validator checks
  end
  
  def generate_report(results)
    # Format and display results
  end
end
```

**Behavior**:
- Create parser and validator instances
- Execute validation checks in sequence
- Collect all validation results
- Pass results to ReportFormatter
- Return appropriate exit code

### 6. ReportFormatter

**Responsibility**: Format validation results for console output

**Interface**:
```ruby
class ReportFormatter
  def initialize(results)
    @results = results
  end
  
  def format
    # Returns formatted string for console output
  end
  
  private
  
  def format_header
    # Report title and timestamp
  end
  
  def format_section(section_name, results)
    # Format results for one validation type
  end
  
  def format_summary
    # Overall pass/fail counts
  end
  
  def colorize(text, color)
    # Add ANSI color codes
  end
end
```

**Behavior**:
- Group results by validation type (presence, paths, initialization)
- Use visual indicators: ✓ (green) for pass, ✗ (red) for fail
- Display summary with total counts
- Use ANSI color codes for better readability
- Format output in clear sections

## Data Models

### SubmoduleEntry
```ruby
{
  name: "core_gem/core",
  path: "core_gem/core",
  url: "https://github.com/magenticmarketactualskill/active_dataflow_core"
}
```

### ValidationResult
```ruby
{
  submodule_name: "core_gem/core",
  check_type: :path_exists,
  status: :fail,
  message: "Directory not found: core_gem/core. Expected at: /path/to/repo/core_gem/core"
}
```

## Error Handling

### File System Errors
- **Missing .gitmodules**: Report "No submodules configured" and exit with code 0
- **Unreadable .gitmodules**: Report parsing error and exit with code 1
- **Permission errors**: Report specific file/directory with permission issue

### Git Command Errors
- **Not a git repository**: Display error message and exit with code 1
- **Git not installed**: Display error message suggesting git installation

### Malformed Configuration
- **Invalid .gitmodules format**: Report line number and parsing error
- **Missing required fields**: Report which submodule is missing path or URL

## Testing Strategy

### Unit Tests

1. **GitModulesParser Tests**
   - Parse valid .gitmodules file
   - Handle missing .gitmodules file
   - Handle malformed .gitmodules file
   - Extract correct name, path, and URL values

2. **PathValidator Tests**
   - Detect existing paths (pass)
   - Detect missing paths (fail)
   - Detect absolute paths (fail)
   - Handle permission errors gracefully

3. **InitValidator Tests**
   - Detect initialized submodules (pass)
   - Detect uninitialized submodules (fail)
   - Detect empty directories (fail)
   - Handle missing directories gracefully

4. **ReportFormatter Tests**
   - Format pass results with green checkmark
   - Format fail results with red X
   - Generate correct summary counts
   - Group results by validation type

### Integration Tests

1. **Full Report Generation**
   - Create test repository with .gitmodules
   - Create some valid and some invalid submodule directories
   - Run report command
   - Verify output format and exit code

2. **Edge Cases**
   - Empty repository (no .gitmodules)
   - All submodules valid
   - All submodules invalid
   - Mixed valid/invalid submodules

## Implementation Notes

### File Parsing Approach
Use simple regex-based parsing for `.gitmodules` rather than shelling out to `git config`:
- More portable (doesn't require git commands)
- Easier to test
- Faster for simple validation

### Exit Codes
- `0`: All checks passed or no submodules configured
- `1`: One or more validation checks failed
- `2`: Script error (not a git repo, invalid arguments, etc.)

### Output Format Example
```
Submodule Configuration Report
Generated: 2025-11-13 10:30:45
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Submodule Configuration Check
  ✓ Found .gitmodules file
  ✓ Parsed 4 submodule entries

📁 Path Validation
  ✗ core_gem/core
    Directory not found: core_gem/core
    Suggestion: Check if path should be submodules/core/core
  ✗ runtime_gems/rails_heartbeat_app
    Directory not found: runtime_gems/rails_heartbeat_app
    Suggestion: Check if path should be submodules/runtime/heartbeat_app
  ✓ example_apps/heartbeat_ar2ar

🔧 Initialization Check
  ✓ example_apps/heartbeat_ar2ar - Initialized
  ⚠ submodules/core/core - Directory exists but not in .gitmodules

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary: 3 passed, 2 failed
Exit code: 1
```

### Performance Considerations
- All checks are file system operations (fast)
- No git command execution required for basic validation
- Sequential processing is sufficient (no need for parallelization)
- Expected runtime: < 100ms for typical repositories

### Future Enhancements
- Add `--fix` option to automatically update .gitmodules paths
- Add `--json` option for machine-readable output
- Add `--verbose` option for detailed diagnostic information
- Support for nested submodules
