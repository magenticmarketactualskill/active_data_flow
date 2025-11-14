# Design Document: Submoduler Defaults

## Overview

This feature adds support for default configuration values in the parent `.submoduler.ini` file that can be overridden by individual submodules. The design extends the existing INI parsing infrastructure to support a `[default]` section in both parent and child `.submoduler.ini` files, with child values taking precedence over parent defaults.

The primary use case is the `require_test` configuration option, which determines whether test failures should cause the test command to exit with a failure code.

## Architecture

### Configuration Hierarchy

```
Parent .submoduler.ini [default] section
    ↓ (provides defaults)
Child .submoduler.ini [default] section
    ↓ (overrides parent)
Final Configuration (used by commands)
```

### Component Interaction

```
SubmodulerIniParser
    ├─→ Reads parent [default] section
    ├─→ Reads child [default] sections
    └─→ Creates SubmoduleEntry with merged config

SubmoduleEntry
    ├─→ Stores configuration hash
    └─→ Provides config accessor methods

TestCommand
    ├─→ Reads require_test from SubmoduleEntry
    └─→ Adjusts exit code based on config

ReportCommand
    ├─→ Detects configuration overrides
    └─→ Displays override information
```

## Components and Interfaces

### 1. Configuration Storage (SubmoduleEntry)

**Purpose**: Store configuration values for each submodule

**Changes**:
- Add `config` attribute to store configuration hash
- Add `config_overrides` attribute to track which values override parent defaults
- Add helper method `require_test?` to check test requirement

**Interface**:
```ruby
class SubmoduleEntry
  attr_reader :name, :path, :url, :parent_url, :config, :config_overrides
  
  def initialize(name:, path:, url:, parent_url: nil, config: {}, config_overrides: [])
    # ...
  end
  
  def require_test?
    # Returns boolean, defaults to false if not set
  end
end
```

### 2. Configuration Parser (SubmodulerIniParser)

**Purpose**: Parse and merge default configurations from parent and child INI files

**Changes**:
- Add method to parse parent `[default]` section
- Modify `parse_submodule_ini` to read child `[default]` section
- Implement configuration merging logic
- Track which values are overrides

**New Methods**:
```ruby
def parse_parent_defaults
  # Returns hash of default configuration from parent .submoduler.ini
end

def merge_configurations(parent_defaults, child_defaults)
  # Merges configurations, child takes precedence
  # Returns: { config: merged_hash, overrides: array_of_keys }
end
```

**Modified Methods**:
- `parse_submodule_ini`: Now reads `[default]` section and merges with parent defaults
- `extract_submodule_info`: Passes configuration to SubmoduleEntry constructor

### 3. Test Enforcement (TestCommand)

**Purpose**: Respect `require_test` configuration when determining exit codes

**Changes**:
- Check `require_test?` for each submodule
- Separate required test failures from optional test failures
- Only exit with code 1 if required tests fail

**Modified Logic**:
```ruby
def determine_exit_code(test_results, entries)
  # Check if any required tests failed
  required_failures = test_results.select do |result|
    entry = entries.find { |e| e.name == result[:name] }
    entry.require_test? && (result[:status] == :failed || result[:status] == :error)
  end
  
  required_failures.any? ? 1 : 0
end
```

### 4. Override Reporting (ReportCommand)

**Purpose**: Display configuration overrides in the report output

**Changes**:
- Add new section to report showing configuration overrides
- Group overrides by configuration key
- Show parent default vs child override value

**New Component**: `ConfigurationReportFormatter`
```ruby
class ConfigurationReportFormatter
  def initialize(entries)
    @entries = entries
  end
  
  def format
    # Returns formatted string showing overrides
  end
  
  private
  
  def group_overrides_by_key
    # Groups all overrides by configuration key
  end
end
```

## Data Models

### Configuration Hash Structure

```ruby
{
  'require_test' => 'true',  # String values from INI file
  # Future configuration options can be added here
}
```

### SubmoduleEntry Extended Structure

```ruby
SubmoduleEntry.new(
  name: 'core/core',
  path: 'submodules/core/core',
  url: 'https://github.com/org/core.git',
  parent_url: 'https://github.com/org/parent.git',
  config: {
    'require_test' => 'true'
  },
  config_overrides: ['require_test']  # Keys that override parent
)
```

### INI File Format

**Parent .submoduler.ini**:
```ini
[default]
require_test = true

[submodule "core/core"]
path = submodules/core/core
url = https://github.com/org/core.git
```

**Child .submoduler.ini** (with override):
```ini
[parent]
url = https://github.com/org/parent.git

[default]
require_test = false
```

**Child .submoduler.ini** (without override):
```ini
[parent]
url = https://github.com/org/parent.git

# No [default] section - uses parent defaults
```

## Error Handling

### Invalid Configuration Values

- **Issue**: Non-boolean value for `require_test`
- **Handling**: Treat as `false` and emit warning
- **Example**: `require_test = maybe` → warning + default to `false`

### Missing Parent INI

- **Issue**: Child references parent defaults but parent INI doesn't exist
- **Handling**: Use empty defaults, no error
- **Rationale**: Child can still function independently

### Malformed [default] Section

- **Issue**: Invalid key-value pairs in `[default]` section
- **Handling**: Skip invalid pairs, emit warning, continue with valid pairs
- **Example**: `invalid line` → warning + skip line

### Configuration Key Conflicts

- **Issue**: Unknown configuration keys in `[default]` section
- **Handling**: Store but ignore unknown keys (forward compatibility)
- **Rationale**: Allows new config options without breaking old versions

## Testing Strategy

### Unit Tests

1. **IniFileParser**: Verify `[default]` section parsing
   - Parse valid `[default]` section
   - Handle empty `[default]` section
   - Handle malformed entries in `[default]`

2. **SubmodulerIniParser**: Test configuration merging
   - Parse parent defaults
   - Merge parent and child configurations
   - Track overrides correctly
   - Handle missing parent defaults
   - Handle missing child defaults

3. **SubmoduleEntry**: Test configuration accessors
   - `require_test?` returns correct boolean
   - Handle missing `require_test` config
   - Handle invalid `require_test` values

4. **TestCommand**: Test exit code logic
   - Exit 0 when all required tests pass
   - Exit 1 when required tests fail
   - Exit 0 when optional tests fail
   - Respect `require_test` configuration

### Integration Tests

1. **End-to-End Configuration Flow**
   - Create parent with defaults
   - Create child with override
   - Verify merged configuration
   - Run test command and verify exit code

2. **Report Command Integration**
   - Verify override reporting
   - Check formatting of configuration section
   - Ensure overrides are grouped correctly

### Test Data

Create fixture directories with:
- Parent `.submoduler.ini` with `[default]` section
- Multiple child `.submoduler.ini` files (some with overrides, some without)
- Test scripts that pass/fail to verify exit code behavior

## Implementation Notes

### Boolean Parsing

The `require_test` value is stored as a string in the INI file. Convert to boolean using:
```ruby
def parse_boolean(value)
  return false if value.nil?
  value.to_s.downcase == 'true'
end
```

### Backward Compatibility

- Existing `.submoduler.ini` files without `[default]` sections continue to work
- Default behavior (no `require_test` set) treats tests as optional
- No breaking changes to existing commands or file formats

### Future Extensibility

The `[default]` section design supports additional configuration options:
- `require_lint`: Enforce linting checks
- `auto_update`: Enable automatic updates
- `test_timeout`: Set test timeout values
- Any key-value pair can be added without code changes to the parser

### Performance Considerations

- Parent defaults are parsed once per command execution
- Configuration merging happens during submodule entry creation
- No additional file I/O beyond existing INI parsing
- Minimal memory overhead (one hash per submodule)
