# Requirements Document

## Introduction

This document specifies the requirements for a `submoduler.rb` Ruby script that provides a `report` command to validate git submodule configuration in a repository. The tool ensures that submodules are properly configured, that the `.gitmodules` file has correct local paths, and that the actual submodule directories exist and are properly initialized.

The script is designed to help developers quickly identify configuration issues with git submodules in a monorepo structure where multiple gems and example applications are managed as submodules.

## Glossary

- **Submoduler**: The Ruby script tool for managing and validating git submodules
- **GitModules**: The `.gitmodules` configuration file that defines submodule mappings
- **SubmodulePath**: The local filesystem path where a submodule is checked out
- **SubmoduleURL**: The remote git repository URL for a submodule
- **SubmoduleConfiguration**: The combination of path and URL that defines a submodule
- **Repository**: The parent git repository containing submodules
- **LocalConfiguration**: The path mapping in `.gitmodules` that points to local directories

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

### Requirement 7: Git Integration

**User Story:** As a developer, I want the tool to use git commands for validation, so that results are consistent with git's own submodule state.

#### Acceptance Criteria

1. THE Submoduler SHALL use `git config --file .gitmodules` to read submodule configuration
2. THE Submoduler SHALL use `git submodule status` to check initialization state
3. THE Submoduler SHALL verify that the current directory is a git repository
4. THE Submoduler SHALL handle cases where git commands are not available
5. THE Submoduler SHALL report git command errors with helpful context
