# Requirements Document

## Introduction

The submoduler-defaults feature allows setting default configuration values in the parent .submoduler.ini file that can be overridden by individual submodules in their child .submoduler.ini files. This provides centralized configuration with flexibility for exceptions.

## Glossary

- **Parent .submoduler.ini**: The .submoduler.ini file at the repository root
- **Child .submoduler.ini**: A .submoduler.ini file in a submodule directory
- **Default Configuration**: Settings defined in the [default] section of parent .submoduler.ini
- **Override**: A child .submoduler.ini setting that supersedes the parent default

## Requirements

### Requirement 1: Parent Default Configuration

**User Story:** As a developer, I want to set default configuration for all submodules in the parent .submoduler.ini, so that I don't repeat settings in each submodule

#### Acceptance Criteria

1. THE system SHALL read the [default] section from parent .submoduler.ini
2. THE system SHALL parse key-value pairs in the [default] section
3. THE system SHALL apply default values to all submodules
4. THE system SHALL support require_test as a default configuration option
5. THE system SHALL treat require_test=true as requiring tests for all submodules

### Requirement 2: Child Override Configuration

**User Story:** As a developer, I want to override parent defaults in specific submodules, so that I can handle exceptions

#### Acceptance Criteria

1. THE system SHALL read the [default] section from child .submoduler.ini files
2. WHEN a child defines a setting, THE system SHALL use the child value instead of the parent default
3. THE system SHALL support overriding require_test in child .submoduler.ini
4. WHEN require_test is not defined in child, THE system SHALL use the parent default
5. THE system SHALL merge parent defaults with child overrides

### Requirement 3: Test Requirement Enforcement

**User Story:** As a developer, I want to enforce test requirements based on configuration, so that critical submodules must have passing tests

#### Acceptance Criteria

1. WHEN require_test=true for a submodule, THE system SHALL fail if tests do not pass
2. WHEN require_test=false for a submodule, THE system SHALL allow test failures
3. THE system SHALL report which submodules have require_test enabled
4. THE system SHALL exit with code 1 when required tests fail
5. THE system SHALL exit with code 0 when optional tests fail

### Requirement 4: Override Reporting

**User Story:** As a developer, I want to see which submodules override parent defaults, so that I understand the configuration

#### Acceptance Criteria

1. THE system SHALL report overrides in the report command
2. WHEN a child overrides a parent default, THE system SHALL display the override
3. THE system SHALL show both the parent default and child override values
4. THE system SHALL group overrides by configuration key
5. THE system SHALL use a distinct visual indicator for overrides
