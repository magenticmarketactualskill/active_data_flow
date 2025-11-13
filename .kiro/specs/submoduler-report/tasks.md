# Implementation Plan

- [x] 1. Create core data structures and models
  - Implement `SubmoduleEntry` class to represent parsed submodule configuration
  - Implement `ValidationResult` class to represent validation check outcomes
  - _Requirements: 1.3, 2.5, 3.5_

- [x] 2. Implement GitModulesParser
  - [x] 2.1 Create GitModulesParser class with file reading capability
    - Implement `initialize` method accepting repo_root parameter
    - Implement `exists?` method to check for .gitmodules file
    - Implement file reading logic for .gitmodules
    - _Requirements: 1.1, 1.2_
  
  - [x] 2.2 Implement .gitmodules parsing logic
    - Write regex patterns to match `[submodule "name"]` sections
    - Extract `path` and `url` key-value pairs from each section
    - Build and return array of SubmoduleEntry objects
    - Handle malformed files with appropriate error messages
    - _Requirements: 1.3, 5.4_

- [x] 3. Implement PathValidator
  - [x] 3.1 Create PathValidator class structure
    - Implement `initialize` method accepting repo_root and submodule_entries
    - Implement main `validate` method that returns ValidationResult array
    - _Requirements: 2.1, 2.5_
  
  - [x] 3.2 Implement path existence checks
    - Write `check_path_exists` method using File.directory?
    - Write `check_path_is_relative` method to validate path format
    - Generate ValidationResult objects for each check
    - Include helpful failure messages with actual vs expected paths
    - _Requirements: 2.2, 2.3, 2.4, 5.2_

- [x] 4. Implement InitValidator
  - [x] 4.1 Create InitValidator class structure
    - Implement `initialize` method accepting repo_root and submodule_entries
    - Implement main `validate` method that returns ValidationResult array
    - _Requirements: 3.1, 3.5_
  
  - [x] 4.2 Implement initialization checks
    - Write `check_git_present` method to detect .git file or directory
    - Write `check_directory_empty` method to check for content
    - Generate ValidationResult objects distinguishing "not initialized" from "not checked out"
    - _Requirements: 3.2, 3.3, 3.4_

- [x] 5. Implement ReportFormatter
  - [x] 5.1 Create ReportFormatter class with basic structure
    - Implement `initialize` method accepting validation results
    - Implement main `format` method that returns formatted string
    - _Requirements: 4.2, 4.3_
  
  - [x] 5.2 Implement output formatting methods
    - Write `format_header` method with title and timestamp
    - Write `format_section` method to group results by validation type
    - Write `format_summary` method with pass/fail counts
    - Write `colorize` method to add ANSI color codes (green for pass, red for fail)
    - Use ✓ and ✗ symbols for visual indicators
    - _Requirements: 4.1, 4.3, 4.4_

- [x] 6. Implement ReportCommand orchestrator
  - [x] 6.1 Create ReportCommand class structure
    - Implement `initialize` method accepting repo_root
    - Implement main `execute` method that returns exit code
    - _Requirements: 4.5_
  
  - [x] 6.2 Implement validation orchestration
    - Instantiate GitModulesParser and parse submodule entries
    - Instantiate PathValidator and run path validations
    - Instantiate InitValidator and run initialization checks
    - Collect all ValidationResult objects
    - Pass results to ReportFormatter and display output
    - Return exit code 0 if all pass, 1 if any fail
    - _Requirements: 1.4, 1.5, 5.5_

- [x] 7. Implement SubmodulerCLI entry point
  - [x] 7.1 Create SubmodulerCLI class with argument parsing
    - Implement `run` class method accepting args array
    - Implement `parse_command` method to extract command name
    - Implement `show_usage` method to display help text
    - _Requirements: 6.1, 6.2, 6.3_
  
  - [x] 7.2 Implement git repository validation and command routing
    - Verify current directory is a git repository
    - Route to ReportCommand when "report" command is specified
    - Handle invalid commands with usage display
    - Return appropriate exit codes (0, 1, or 2)
    - _Requirements: 6.4, 6.5, 7.4, 7.5_

- [x] 8. Create executable script wrapper
  - Create `bin/submoduler.rb` executable file with shebang
  - Require all necessary classes
  - Call SubmodulerCLI.run(ARGV) and exit with returned code
  - Make file executable with proper permissions
  - _Requirements: 6.4_

- [x] 9. Add error handling throughout
  - Add file system error handling (permissions, missing files)
  - Add git command error handling (not a repo, git not installed)
  - Add malformed configuration handling with helpful messages
  - Ensure all errors include actionable remediation suggestions
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [x] 10. Write unit tests for core components
  - Write tests for GitModulesParser (valid, missing, malformed files)
  - Write tests for PathValidator (existing, missing, absolute paths)
  - Write tests for InitValidator (initialized, uninitialized, empty directories)
  - Write tests for ReportFormatter (pass/fail formatting, summaries, grouping)
  - _Requirements: 1.3, 2.5, 3.5, 4.4_

- [x] 11. Write integration tests
  - Create test repository fixture with .gitmodules
  - Test full report generation with mixed valid/invalid submodules
  - Test edge cases (no .gitmodules, all valid, all invalid)
  - Verify output format and exit codes
  - _Requirements: 4.5, 5.5_
