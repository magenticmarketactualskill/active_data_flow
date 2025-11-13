# Requirements Document

## Introduction

This document specifies the requirements for a `submoduler.rb` Ruby script that provides a `report` command to validate git submodule configuration in a repository. The tool ensures that submodules are properly configured, that the `.gitmodules` file has correct local paths, and that the actual submodule directories exist and are properly initialized.

The script is designed to help developers quickly identify configuration issues with git submodules in a monorepo structure where multiple gems and example applications are managed as submodules.

## Glossary

- **Submoduler**: The Ruby script tool for managing and validating git submodules
- **GitModules**: The `.gitmodules` configuration file that defines submodule mappings and serves as the source of truth
- **SubmodulePath**: The local filesystem path where a submodule is checked out
- **SubmoduleURL**: The remote git repository URL for a submodule
- **SubmoduleName**: The unique identifier for a submodule in the format `category/name` (e.g., `core_gem/core`)
- **SubmoduleConfiguration**: The combination of name, path, and URL that defines a submodule
- **Repository**: The parent git repository containing submodules
- **LocalConfiguration**: The path mapping in `.gitmodules` that points to local directories
- **SubmoduleEntry**: A parsed representation of a submodule configuration containing name, path, and URL
- **ValidationResult**: The outcome of a validation check with status (pass/fail) and optional message
- **MalformedEntry**: A `.gitmodules` entry with syntax errors or duplicate keys
- **GitDirectory**: The `.git` file or directory that indicates a git repository or submodule

## Requirements

### Requirement 1: Submodule Presence Validation

**User Story:** As a developer, I want to verify that submodules are configured in my repository, so that I can ensure the project structure is complete.

#### Acceptance Criteria

1. WHEN the report command runs, THE Submoduler SHALL check if a `.gitmodules` file exists in the repository root
2. IF the `.gitmodules` file does not exist, THEN THE Submoduler SHALL report that no submodules are configured
3. WHEN the `.gitmodules` file exists, THE Submoduler SHALL parse all submodule entries
4. THE Submoduler SHALL report the total count of configured submodules
5. THE Submoduler SHALL display each submodule name with its configured path and URL

### Requirement 2: GitModules Path Validation

**User Story:** As a developer, I want to verify that `.gitmodules` has correct local path configurations, so that I can detect path mismatches before they cause issues.

#### Acceptance Criteria

1. WHEN validating paths, THE Submoduler SHALL read each submodule path from `.gitmodules`
2. THE Submoduler SHALL check if the configured path exists as a directory in the filesystem
3. IF a configured path does not exist, THEN THE Submoduler SHALL report it as a missing directory
4. THE Submoduler SHALL verify that each path is a relative path from the repository root
5. THE Submoduler SHALL report all path validation results with pass or fail status

### Requirement 3: Submodule Initialization Check

**User Story:** As a developer, I want to verify that submodule directories are properly initialized, so that I can identify submodules that need to be updated or initialized.

#### Acceptance Criteria

1. WHEN checking initialization, THE Submoduler SHALL verify that each submodule directory contains a `.git` file or directory
2. IF a submodule directory lacks `.git`, THEN THE Submoduler SHALL report it as uninitialized
3. THE Submoduler SHALL check if the submodule directory is empty
4. IF a submodule directory is empty, THEN THE Submoduler SHALL report it as not checked out
5. THE Submoduler SHALL report initialization status for each configured submodule

### Requirement 4: Report Output Formatting

**User Story:** As a developer, I want clear and readable report output, so that I can quickly understand the status of my submodules.

#### Acceptance Criteria

1. THE Submoduler SHALL display a header indicating the report is running
2. THE Submoduler SHALL group validation results by category (presence, paths, initialization)
3. THE Submoduler SHALL use visual indicators for pass (✓) and fail (✗) statuses
4. THE Submoduler SHALL display a summary section with total counts of passed and failed checks
5. THE Submoduler SHALL exit with status code 0 if all checks pass and non-zero if any check fails

### Requirement 5: Error Handling and Diagnostics

**User Story:** As a developer, I want helpful error messages when validation fails, so that I can quickly fix configuration issues.

#### Acceptance Criteria

1. WHEN a validation check fails, THE Submoduler SHALL display the specific submodule name
2. THE Submoduler SHALL provide actionable error messages describing what is wrong
3. THE Submoduler SHALL suggest remediation steps for common issues
4. IF the `.gitmodules` file is malformed, THEN THE Submoduler SHALL report parsing errors
5. THE Submoduler SHALL continue checking all submodules even if some checks fail

### Requirement 6: Command Line Interface

**User Story:** As a developer, I want a simple command line interface, so that I can easily run the report command.

#### Acceptance Criteria

1. THE Submoduler SHALL accept a `report` command as the first argument
2. WHEN invoked without arguments, THE Submoduler SHALL display usage information
3. THE Submoduler SHALL support a `--help` flag that displays command documentation
4. THE Submoduler SHALL be executable from the repository root directory
5. THE Submoduler SHALL validate that it is being run from a git repository

### Requirement 7: GitModules as Source of Truth

**User Story:** As a developer, I want `.gitmodules` to be the authoritative source for submodule configuration, so that I have a single, reliable reference for all submodule definitions.

#### Acceptance Criteria

1. THE Submoduler SHALL parse `.gitmodules` directly using file I/O operations
2. THE Submoduler SHALL NOT rely on git commands for reading submodule configuration
3. THE Submoduler SHALL validate that `.gitmodules` entries match the INI format specification
4. THE Submoduler SHALL extract submodule name from `[submodule "name"]` section headers
5. THE Submoduler SHALL extract path and url values from key-value pairs within each section

### Requirement 8: Malformed Entry Detection

**User Story:** As a developer, I want to be alerted when `.gitmodules` contains malformed entries, so that I can fix syntax errors before they cause problems.

#### Acceptance Criteria

1. WHEN parsing `.gitmodules`, THE Submoduler SHALL detect duplicate key prefixes in values
2. IF a path value contains `path =` prefix, THEN THE Submoduler SHALL raise a malformed entry error
3. IF a url value contains `url =` prefix, THEN THE Submoduler SHALL raise a malformed entry error
4. THE Submoduler SHALL include the submodule name in malformed entry error messages
5. THE Submoduler SHALL include the problematic line content in error messages

### Requirement 9: Missing Required Fields

**User Story:** As a developer, I want to be notified when submodule entries are incomplete, so that I can ensure all required configuration is present.

#### Acceptance Criteria

1. WHEN a submodule entry lacks a path field, THE Submoduler SHALL raise an error
2. WHEN a submodule entry lacks a url field, THE Submoduler SHALL raise an error
3. THE Submoduler SHALL identify which submodule is missing required fields
4. THE Submoduler SHALL specify which field (path or url) is missing
5. THE Submoduler SHALL fail fast when encountering incomplete entries

### Requirement 10: Submodule Directory Structure

**User Story:** As a developer, I want to ensure submodule directories are properly structured, so that git can manage them correctly.

#### Acceptance Criteria

1. THE Submoduler SHALL verify that each submodule path points to a directory
2. THE Submoduler SHALL check that submodule directories contain a `.git` file (not directory)
3. WHEN a `.git` file exists, THE Submoduler SHALL verify it contains a `gitdir:` reference
4. THE Submoduler SHALL report directories that exist but are not initialized as submodules
5. THE Submoduler SHALL distinguish between missing directories and uninitialized directories

### Requirement 11: Repository Root Detection

**User Story:** As a developer, I want the tool to automatically detect the repository root, so that I can run it from any subdirectory.

#### Acceptance Criteria

1. THE Submoduler SHALL search for `.git` directory in current and parent directories
2. THE Submoduler SHALL identify the repository root as the directory containing `.git`
3. IF no `.git` directory is found, THEN THE Submoduler SHALL report an error
4. THE Submoduler SHALL use the repository root as the base for all path operations
5. THE Submoduler SHALL resolve all submodule paths relative to the repository root

### Requirement 12: Exit Code Semantics

**User Story:** As a developer, I want meaningful exit codes, so that I can use the tool in scripts and CI/CD pipelines.

#### Acceptance Criteria

1. THE Submoduler SHALL exit with code 0 when all validations pass
2. THE Submoduler SHALL exit with code 0 when no submodules are configured
3. THE Submoduler SHALL exit with code 1 when one or more validation checks fail
4. THE Submoduler SHALL exit with code 2 when a script error occurs (not a git repo, invalid arguments)
5. THE Submoduler SHALL exit with code 2 when `.gitmodules` parsing fails

### Requirement 13: Validation Result Aggregation

**User Story:** As a developer, I want to see all validation failures in one report, so that I can fix multiple issues at once.

#### Acceptance Criteria

1. THE Submoduler SHALL collect all validation results before displaying output
2. THE Submoduler SHALL continue validation even when individual checks fail
3. THE Submoduler SHALL group validation results by check type (path, initialization)
4. THE Submoduler SHALL display all failures before exiting
5. THE Submoduler SHALL count total passed and failed checks across all categories

### Requirement 14: Submodule Name Consistency

**User Story:** As a developer, I want submodule names to be consistent and meaningful, so that I can easily identify which submodule has issues.

#### Acceptance Criteria

1. THE Submoduler SHALL display the submodule name from `.gitmodules` in all messages
2. THE Submoduler SHALL use the exact name format from `[submodule "name"]` sections
3. THE Submoduler SHALL preserve name formatting (e.g., `core_gem/core`, not `core/core`)
4. THE Submoduler SHALL use submodule names as identifiers in validation results
5. THE Submoduler SHALL display both name and path when they differ significantly

### Requirement 15: File System Error Handling

**User Story:** As a developer, I want graceful handling of file system errors, so that I understand what went wrong when file operations fail.

#### Acceptance Criteria

1. WHEN `.gitmodules` cannot be read due to permissions, THE Submoduler SHALL report a permission error
2. WHEN a submodule directory cannot be accessed, THE Submoduler SHALL report the specific path
3. THE Submoduler SHALL distinguish between "file not found" and "permission denied" errors
4. THE Submoduler SHALL continue validation for other submodules when one fails
5. THE Submoduler SHALL include the system error message in diagnostic output
