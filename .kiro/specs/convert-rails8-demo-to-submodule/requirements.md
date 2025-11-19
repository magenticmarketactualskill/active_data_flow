# Requirements Document

## Introduction

Convert the `submodules/examples/rails8-demo` directory from a local git repository with a placeholder submodule entry into a properly configured git submodule pointing to a remote repository. This will enable independent version management and proper submodule workflow for the Rails 8 demo application.

## Glossary

- **Parent Repository**: The main `active_data_flow` repository
- **Submodule**: A git repository embedded within another git repository, tracked by commit SHA
- **Remote Repository**: A git repository hosted on a remote server (e.g., GitHub)
- **.gitmodules**: Configuration file that defines submodule mappings in a git repository
- **.submoduler.ini**: Custom configuration file used by the submoduler tool to manage submodules
- **rails8-demo**: The Rails 8 demonstration application located at `submodules/examples/rails8-demo`

## Requirements

### Requirement 1

**User Story:** As a repository maintainer, I want to commit all local changes in rails8-demo to its own repository, so that the work is preserved before converting to a submodule

#### Acceptance Criteria

1. WHEN uncommitted changes exist in rails8-demo, THE Parent Repository SHALL commit all changes to the rails8-demo git repository
2. THE Parent Repository SHALL create a meaningful commit message describing the changes
3. THE Parent Repository SHALL verify the working directory is clean after committing

### Requirement 2

**User Story:** As a repository maintainer, I want to create a remote repository for rails8-demo, so that it can be properly referenced as a submodule

#### Acceptance Criteria

1. THE Parent Repository SHALL provide instructions for creating a remote repository for rails8-demo
2. THE Parent Repository SHALL specify the recommended repository naming convention following the pattern `active_dataflow-examples-rails8-demo`
3. THE Parent Repository SHALL provide the git commands needed to push the local repository to the remote

### Requirement 3

**User Story:** As a repository maintainer, I want to update the submodule configuration files, so that rails8-demo is properly tracked as a submodule

#### Acceptance Criteria

1. THE Parent Repository SHALL update the `.gitmodules` file to reference the remote repository URL instead of the local path
2. THE Parent Repository SHALL add an entry to `.submoduler.ini` for the rails8-demo submodule
3. THE Parent Repository SHALL follow the naming convention used by other example submodules in `.submoduler.ini`
4. THE Parent Repository SHALL ensure the submodule path matches the existing directory structure

### Requirement 4

**User Story:** As a repository maintainer, I want to reinitialize the submodule with the remote URL, so that git properly tracks it as a submodule

#### Acceptance Criteria

1. THE Parent Repository SHALL update the submodule configuration to use the remote URL
2. THE Parent Repository SHALL verify the submodule is properly initialized and tracking the remote repository
3. THE Parent Repository SHALL ensure the submodule commit SHA is recorded in the parent repository

### Requirement 5

**User Story:** As a repository maintainer, I want to validate the submodule configuration, so that I can confirm the conversion was successful

#### Acceptance Criteria

1. THE Parent Repository SHALL run the submoduler validation tool to verify configuration
2. THE Parent Repository SHALL verify that `git submodule status` shows the correct commit SHA
3. THE Parent Repository SHALL confirm that the submodule can be updated using standard git submodule commands
