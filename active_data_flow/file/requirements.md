# ActiveDataFlow File - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-file` gem, which provides Source and Sink implementations for reading and writing files in various formats.

## Glossary

- **File Source**: A source that reads data from local or remote files
- **File Sink**: A sink that writes data to local or remote files
- **Format**: The file format (CSV, JSON, Parquet, etc.)

## Requirements

### Requirement 1: File Source

**User Story:** As a developer, I want a file source, so that I can read data from files for batch processing.

#### Acceptance Criteria

1. THE File gem SHALL provide an ActiveDataFlow::Source::File class
2. THE File source SHALL accept file_path and format configuration
3. THE File source SHALL support CSV format with headers
4. THE File source SHALL support JSON format (line-delimited and array)
5. THE File source SHALL implement the each method to yield records

### Requirement 2: CSV Reading

**User Story:** As a developer, I want CSV file reading, so that I can process tabular data.

#### Acceptance Criteria

1. WHEN reading CSV files, THE File source SHALL parse headers automatically
2. THE File source SHALL convert each row to a hash with header keys
3. THE File source SHALL support custom delimiters
4. THE File source SHALL support custom quote characters
5. THE File source SHALL handle encoding issues gracefully

### Requirement 3: JSON Reading

**User Story:** As a developer, I want JSON file reading, so that I can process structured data.

#### Acceptance Criteria

1. THE File source SHALL support line-delimited JSON (JSONL) format
2. THE File source SHALL support JSON array format
3. THE File source SHALL parse each JSON object into a hash
4. THE File source SHALL handle malformed JSON with errors
5. THE File source SHALL support streaming large JSON files

### Requirement 4: File Sink

**User Story:** As a developer, I want a file sink, so that I can write processed data to files.

#### Acceptance Criteria

1. THE File gem SHALL provide an ActiveDataFlow::Sink::File class
2. THE File sink SHALL accept file_path and format configuration
3. THE File sink SHALL support CSV format output
4. THE File sink SHALL support JSON format output
5. THE File sink SHALL implement the write method to append records

### Requirement 5: Split-Based File Source

**User Story:** As a developer, I want split-based file reading, so that I can process multiple files in parallel.

#### Acceptance Criteria

1. THE File gem SHALL provide an ActiveDataFlow::SourceSupport::File::FileSplit class
2. THE FileSplit SHALL represent a single file
3. THE FileSplit SHALL include file_path
4. THE FileSplit SHALL implement the split_id method
5. THE FileSplit SHALL be serializable

### Requirement 6: File Split Enumerator

**User Story:** As a developer, I want automatic file discovery, so that all files in a directory are processed.

#### Acceptance Criteria

1. THE File gem SHALL provide a FileSplitEnumerator class
2. THE FileSplitEnumerator SHALL discover files in a directory on start
3. THE FileSplitEnumerator SHALL support glob patterns for file matching
4. THE FileSplitEnumerator SHALL assign files to readers on request
5. THE FileSplitEnumerator SHALL signal when no more files are available

### Requirement 7: File Source Reader

**User Story:** As a developer, I want parallel file reading, so that I can process large datasets efficiently.

#### Acceptance Criteria

1. THE File gem SHALL provide a FileSourceReader class
2. THE FileSourceReader SHALL accept file assignments
3. THE FileSourceReader SHALL read from assigned files in poll method
4. THE FileSourceReader SHALL close files after reading
5. THE FileSourceReader SHALL request new files when current file is complete

### Requirement 8: Remote File Support

**User Story:** As a developer, I want remote file access, so that I can read from S3, GCS, or HTTP.

#### Acceptance Criteria

1. THE File gem SHALL support S3 URLs (s3://bucket/key)
2. THE File gem SHALL support GCS URLs (gs://bucket/key)
3. THE File gem SHALL support HTTP/HTTPS URLs
4. THE File gem SHALL handle authentication for remote files
5. THE File gem SHALL stream remote files without full download
