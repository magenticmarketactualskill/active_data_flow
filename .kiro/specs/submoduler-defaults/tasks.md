# Implementation Plan

- [x] 1. Extend SubmoduleEntry to store configuration
  - Add `config` attribute to store configuration hash
  - Add `config_overrides` attribute to track overridden keys
  - Implement `require_test?` helper method that parses boolean from config
  - Update constructor to accept `config` and `config_overrides` parameters
  - _Requirements: 1.1, 1.2, 1.3, 2.2, 2.5_

- [x] 2. Implement configuration parsing in SubmodulerIniParser
- [x] 2.1 Add parent defaults parsing
  - Implement `parse_parent_defaults` method to read `[default]` section from parent .submoduler.ini
  - Return empty hash if parent INI doesn't exist or has no `[default]` section
  - Handle parsing errors gracefully with warnings
  - _Requirements: 1.1, 1.2_

- [x] 2.2 Add configuration merging logic
  - Implement `merge_configurations` method that takes parent and child default hashes
  - Child values override parent values for matching keys
  - Track which keys are overrides in separate array
  - Return both merged config and override list
  - _Requirements: 2.1, 2.2, 2.4, 2.5_

- [x] 2.3 Integrate configuration into submodule parsing
  - Modify `parse_submodule_ini` to read child `[default]` section
  - Call `parse_parent_defaults` once and cache result
  - Call `merge_configurations` for each submodule
  - Pass merged config and overrides to SubmoduleEntry constructor
  - _Requirements: 1.3, 2.1, 2.2, 2.5_

- [x] 3. Update TestCommand to respect require_test configuration
- [x] 3.1 Modify exit code determination logic
  - Change `execute` method to check `require_test?` for each submodule
  - Only count failures as errors if `require_test?` returns true
  - Exit with code 1 only when required tests fail
  - Exit with code 0 when optional tests fail
  - _Requirements: 3.1, 3.2, 3.4, 3.5_

- [x] 3.2 Add configuration reporting in verbose mode
  - Display which submodules have `require_test` enabled in verbose output
  - Show configuration source (parent default vs child override)
  - _Requirements: 3.3_

- [x] 4. Add configuration override reporting to ReportCommand
- [x] 4.1 Create ConfigurationReportFormatter
  - Implement new formatter class to display configuration overrides
  - Group overrides by configuration key
  - Show parent default value and child override value for each submodule
  - Use distinct visual indicator (e.g., "→" or "OVERRIDE") for overrides
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 4.2 Integrate configuration reporting into ReportCommand
  - Add configuration section to report output
  - Call ConfigurationReportFormatter with parsed entries
  - Display configuration section after validation results
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 5. Add comprehensive test coverage
- [x] 5.1 Write unit tests for SubmoduleEntry configuration
  - Test `require_test?` with true, false, and missing values
  - Test boolean parsing for various string formats
  - Test config_overrides tracking
  - _Requirements: 1.1, 1.2, 1.3, 2.2, 2.5_

- [x] 5.2 Write unit tests for configuration parsing
  - Test `parse_parent_defaults` with valid, empty, and missing parent INI
  - Test `merge_configurations` with various parent/child combinations
  - Test override tracking in merge logic
  - Test error handling for malformed `[default]` sections
  - _Requirements: 1.1, 1.2, 2.1, 2.2, 2.4, 2.5_

- [x] 5.3 Write integration tests for TestCommand
  - Test exit code 0 when all required tests pass
  - Test exit code 1 when required tests fail
  - Test exit code 0 when optional tests fail
  - Test configuration reporting in verbose mode
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [x] 5.4 Write integration tests for ReportCommand
  - Test configuration section appears in report
  - Test override formatting and grouping
  - Test report with no overrides
  - Test report with multiple overrides
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 5.5 Create end-to-end test fixtures
  - Create fixture directory with parent .submoduler.ini containing defaults
  - Create multiple child .submoduler.ini files with and without overrides
  - Add test scripts that pass and fail
  - Verify complete workflow from parsing to command execution
  - _Requirements: All_
