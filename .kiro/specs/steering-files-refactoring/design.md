# Steering Files Refactoring Design

## Overview

Refactor the steering files architecture to make vendored submoduler gems the source of truth for documentation, with automatic symlink management through CLI commands.

## Current State

### Documentation Location
- **Source of Truth**: `.kiro/steering/` in active_data_flow repository
- **Subgem Access**: Manual symlinks created in each subgem's `.kiro/steering/`
- **Maintenance**: Manual updates required when adding new steering files

### Current Files
```
active_data_flow/
├── .kiro/steering/
│   ├── design_gem.md
│   ├── dry.md
│   ├── gemfiles.md
│   ├── glossary.md
│   ├── product.md
│   ├── structure.md
│   ├── subgems_parent.md
│   ├── submodules_parent.md
│   ├── submoduler_child.md
│   ├── submoduler_gem.md
│   ├── tech.md
│   └── test_driven_design.md
└── subgems/
    └── component/
        └── .kiro/steering/
            └── [12 symlinks to parent]
```

### Problems
1. **Duplication**: Steering files duplicated across projects using submoduler
2. **Version Drift**: Each project may have different versions of steering docs
3. **Manual Maintenance**: Adding new steering files requires manual symlink creation
4. **No Single Source**: Documentation scattered across repositories

## Proposed State

### New Architecture

```
vendor/submoduler_parent/
├── .kiro/steering/
│   ├── subgems_parent.md          # Source of truth
│   ├── submodules_parent.md       # Source of truth
│   └── submoduler_gem.md          # Source of truth
└── lib/submoduler_parent/
    ├── cli.rb
    ├── symlink_build_command.rb   # NEW
    └── init_command.rb             # MODIFIED

vendor/submoduler_child/
├── .kiro/steering/
│   └── submoduler_child.md        # Source of truth
└── lib/submoduler_child/
    ├── cli.rb
    ├── symlink_build_command.rb   # NEW
    └── init_command.rb             # MODIFIED

active_data_flow/
├── .kiro/steering/
│   ├── [project-specific files]
│   ├── subgems_parent.md          # Symlink to vendor/submoduler_parent
│   ├── submodules_parent.md       # Symlink to vendor/submoduler_parent
│   ├── submoduler_gem.md          # Symlink to vendor/submoduler_parent
│   └── submoduler_child.md        # Symlink to vendor/submoduler_child
└── subgems/
    └── component/
        └── .kiro/steering/
            └── [symlinks auto-created by CLI]
```

## Design Details

### 1. Steering Files Organization

#### Parent Gem Files (vendor/submoduler_parent/.kiro/steering/)
- `subgems_parent.md` - Subgem development guide
- `submodules_parent.md` - Parent gem and vendor guide
- `submoduler_gem.md` - Base submoduler guide

#### Child Gem Files (vendor/submoduler_child/.kiro/steering/)
- `submoduler_child.md` - Child gem usage guide

#### Project-Specific Files (active_data_flow/.kiro/steering/)
- `design_gem.md` - Project-specific gem design
- `dry.md` - Project-specific DRY principles
- `gemfiles.md` - Project-specific Gemfile patterns
- `glossary.md` - Project-specific terminology
- `product.md` - Project-specific product overview
- `structure.md` - Project-specific structure
- `tech.md` - Project-specific tech stack
- `test_driven_design.md` - Project-specific testing

### 2. Symlink Build Command

#### Command: `symlink_build`

**Purpose**: Automatically create/update symlinks from vendored gems to project

**Usage**:
```bash
# From parent repository
bundle exec submoduler_parent symlink_build

# From child component
bundle exec submoduler_child symlink_build
```

**Behavior**:

**Parent Command** (`submoduler_parent symlink_build`):
1. Detect current directory is parent repository
2. Create `.kiro/steering/` if not exists
3. Create symlinks from vendor gems to parent:
   - `vendor/submoduler_parent/.kiro/steering/*.md` → `.kiro/steering/`
   - `vendor/submoduler_child/.kiro/steering/*.md` → `.kiro/steering/`
4. Report created/updated symlinks
5. Validate all symlinks are working

**Child Command** (`submoduler_child symlink_build`):
1. Detect current directory is child component
2. Read `.submoduler.ini` to find parent path
3. Create `.kiro/steering/` if not exists
4. Create symlinks from vendor to child:
   - `../../../vendor/submoduler_parent/.kiro/steering/*.md` → `.kiro/steering/`
   - `../../../vendor/submoduler_child/.kiro/steering/*.md` → `.kiro/steering/`
   - `../../../.kiro/steering/*.md` → `.kiro/steering/` (project-specific files)
5. Report created/updated symlinks
6. Validate all symlinks are working

### 3. Init Command Enhancement

#### Modified: `init` command

**Current Behavior**:
- Creates `.submoduler.ini`
- Creates directory structure
- Sets up basic configuration

**New Behavior**:
- All current behavior PLUS:
- Automatically calls `symlink_build` after initialization
- Reports symlink creation status

**Parent Init** (`submoduler_parent init`):
```bash
bundle exec submoduler_parent init --name my-project
# Creates structure
# Calls symlink_build automatically
# Reports: "✓ Created 3 steering symlinks"
```

**Child Init** (`submoduler_child init`):
```bash
bundle exec submoduler_child init --name my-component
# Creates structure
# Calls symlink_build automatically
# Reports: "✓ Created 12 steering symlinks"
```

## Implementation Plan

### Phase 1: Move Steering Files

1. **Create directories in vendor gems**:
   ```bash
   mkdir -p vendor/submoduler_parent/.kiro/steering
   mkdir -p vendor/submoduler_child/.kiro/steering
   ```

2. **Move files to vendor gems**:
   - Move `subgems_parent.md`, `submodules_parent.md`, `submoduler_gem.md` → `vendor/submoduler_parent/.kiro/steering/`
   - Move `submoduler_child.md` → `vendor/submoduler_child/.kiro/steering/`

3. **Create symlinks in parent**:
   ```bash
   cd .kiro/steering
   ln -sf ../../vendor/submoduler_parent/.kiro/steering/subgems_parent.md
   ln -sf ../../vendor/submoduler_parent/.kiro/steering/submodules_parent.md
   ln -sf ../../vendor/submoduler_parent/.kiro/steering/submoduler_gem.md
   ln -sf ../../vendor/submoduler_child/.kiro/steering/submoduler_child.md
   ```

4. **Update subgem symlinks**:
   - Point to parent's symlinks (which point to vendor)
   - No change needed - existing symlinks still work

### Phase 2: Implement symlink_build Command

1. **Create `symlink_build_command.rb` in parent gem**:
   ```ruby
   # vendor/submoduler_parent/lib/submoduler_parent/symlink_build_command.rb
   module SubmodulerParent
     class SymlinkBuildCommand
       def self.run
         # Implementation
       end
     end
   end
   ```

2. **Create `symlink_build_command.rb` in child gem**:
   ```ruby
   # vendor/submoduler_child/lib/submoduler_child/symlink_build_command.rb
   module SubmodulerChild
     class SymlinkBuildCommand
       def self.run
         # Implementation
       end
     end
   end
   ```

3. **Register commands in CLIs**:
   - Update `vendor/submoduler_parent/lib/submoduler_parent/cli.rb`
   - Update `vendor/submoduler_child/lib/submoduler_child/cli.rb`

### Phase 3: Enhance Init Commands

1. **Modify parent init**:
   ```ruby
   # vendor/submoduler_parent/lib/submoduler_parent/init_command.rb
   def run
     # Existing initialization
     # ...
     
     # NEW: Auto-create symlinks
     SymlinkBuildCommand.run
   end
   ```

2. **Modify child init**:
   ```ruby
   # vendor/submoduler_child/lib/submoduler_child/init_command.rb
   def run
     # Existing initialization
     # ...
     
     # NEW: Auto-create symlinks
     SymlinkBuildCommand.run
   end
   ```

### Phase 4: Update Documentation

1. Update `.kiro/steering/submoduler_gem.md`
2. Update `.kiro/steering/submoduler_child.md`
3. Update `.kiro/steering/submodules_parent.md`
4. Update `.kiro/steering/subgems_parent.md`
5. Add migration guide for existing projects

## Detailed Implementation

### SymlinkBuildCommand for Parent

```ruby
# vendor/submoduler_parent/lib/submoduler_parent/symlink_build_command.rb
require 'fileutils'

module SubmodulerParent
  class SymlinkBuildCommand
    VENDOR_PARENT_STEERING = 'vendor/submoduler_parent/.kiro/steering'
    VENDOR_CHILD_STEERING = 'vendor/submoduler_child/.kiro/steering'
    PROJECT_STEERING = '.kiro/steering'

    def self.run
      new.run
    end

    def run
      ensure_directory_exists
      create_symlinks_from_vendor
      validate_symlinks
      report_results
    end

    private

    def ensure_directory_exists
      FileUtils.mkdir_p(PROJECT_STEERING) unless Dir.exist?(PROJECT_STEERING)
    end

    def create_symlinks_from_vendor
      @created = []
      @updated = []
      @skipped = []

      # Link from parent vendor gem
      link_files_from(VENDOR_PARENT_STEERING, '../../')
      
      # Link from child vendor gem
      link_files_from(VENDOR_CHILD_STEERING, '../../')
    end

    def link_files_from(source_dir, relative_prefix)
      return unless Dir.exist?(source_dir)

      Dir.glob("#{source_dir}/*.md").each do |source_file|
        filename = File.basename(source_file)
        target = File.join(PROJECT_STEERING, filename)
        source_relative = File.join(relative_prefix, source_file)

        if File.symlink?(target)
          @updated << filename
          File.delete(target)
        elsif File.exist?(target)
          @skipped << filename
          next
        else
          @created << filename
        end

        File.symlink(source_relative, target)
      end
    end

    def validate_symlinks
      @broken = []
      
      Dir.glob("#{PROJECT_STEERING}/*.md").each do |link|
        next unless File.symlink?(link)
        @broken << File.basename(link) unless File.exist?(link)
      end
    end

    def report_results
      puts "\n=== Symlink Build Results ==="
      puts "✓ Created: #{@created.length}" if @created.any?
      puts "↻ Updated: #{@updated.length}" if @updated.any?
      puts "⊘ Skipped: #{@skipped.length} (files exist)" if @skipped.any?
      puts "✗ Broken: #{@broken.length}" if @broken.any?
      
      if @broken.any?
        puts "\nBroken symlinks:"
        @broken.each { |f| puts "  - #{f}" }
      end
    end
  end
end
```

### SymlinkBuildCommand for Child

```ruby
# vendor/submoduler_child/lib/submoduler_child/symlink_build_command.rb
require 'fileutils'
require 'ini'

module SubmodulerChild
  class SymlinkBuildCommand
    PROJECT_STEERING = '.kiro/steering'

    def self.run
      new.run
    end

    def run
      ensure_directory_exists
      find_parent_path
      create_symlinks_to_parent
      validate_symlinks
      report_results
    end

    private

    def ensure_directory_exists
      FileUtils.mkdir_p(PROJECT_STEERING) unless Dir.exist?(PROJECT_STEERING)
    end

    def find_parent_path
      config = INI.load_file('.submoduler.ini')
      @parent_path = config['parent']['path'] || '../../'
      @parent_steering = File.join(@parent_path, '.kiro/steering')
    end

    def create_symlinks_to_parent
      @created = []
      @updated = []
      @skipped = []

      unless Dir.exist?(@parent_steering)
        puts "Warning: Parent steering directory not found: #{@parent_steering}"
        return
      end

      # Calculate relative path from child steering to parent steering
      relative_path = File.join('../../../', @parent_steering)

      Dir.glob("#{@parent_steering}/*.md").each do |source_file|
        filename = File.basename(source_file)
        target = File.join(PROJECT_STEERING, filename)
        source_relative = File.join(relative_path, filename)

        if File.symlink?(target)
          @updated << filename
          File.delete(target)
        elsif File.exist?(target)
          @skipped << filename
          next
        else
          @created << filename
        end

        File.symlink(source_relative, target)
      end
    end

    def validate_symlinks
      @broken = []
      
      Dir.glob("#{PROJECT_STEERING}/*.md").each do |link|
        next unless File.symlink?(link)
        @broken << File.basename(link) unless File.exist?(link)
      end
    end

    def report_results
      puts "\n=== Symlink Build Results ==="
      puts "✓ Created: #{@created.length}" if @created.any?
      puts "↻ Updated: #{@updated.length}" if @updated.any?
      puts "⊘ Skipped: #{@skipped.length} (files exist)" if @skipped.any?
      puts "✗ Broken: #{@broken.length}" if @broken.any?
      
      if @broken.any?
        puts "\nBroken symlinks:"
        @broken.each { |f| puts "  - #{f}" }
      end
    end
  end
end
```

## Benefits

### 1. Single Source of Truth
- Steering files live in vendor gems
- All projects using submoduler get same documentation
- Updates propagate through gem updates

### 2. Automatic Maintenance
- `symlink_build` command creates all symlinks
- `init` command sets up symlinks automatically
- No manual symlink management

### 3. Version Control
- Documentation versioned with gems
- Projects can pin to specific gem versions
- Clear upgrade path for documentation

### 4. Consistency
- All projects using submoduler have same structure
- Reduces documentation drift
- Easier onboarding for new projects

## Migration Path

### For Existing Projects

1. **Update vendor gems**:
   ```bash
   cd vendor/submoduler_parent && git pull
   cd vendor/submoduler_child && git pull
   ```

2. **Remove old symlinks**:
   ```bash
   rm .kiro/steering/subgems_parent.md
   rm .kiro/steering/submodules_parent.md
   rm .kiro/steering/submoduler_gem.md
   rm .kiro/steering/submoduler_child.md
   ```

3. **Run symlink_build**:
   ```bash
   bundle exec submoduler_parent symlink_build
   ```

4. **Update subgems**:
   ```bash
   cd subgems/my-component
   bundle exec submoduler_child symlink_build
   ```

### For New Projects

1. **Initialize parent**:
   ```bash
   bundle exec submoduler_parent init --name my-project
   # Symlinks created automatically
   ```

2. **Initialize children**:
   ```bash
   cd subgems/my-component
   bundle exec submoduler_child init --name my-component
   # Symlinks created automatically
   ```

## Testing Strategy

### Unit Tests
- Test symlink creation logic
- Test path resolution
- Test error handling

### Integration Tests
- Test full init workflow
- Test symlink_build in various scenarios
- Test with missing directories

### Manual Testing
- Test in active_data_flow
- Test in new project
- Test symlink updates

## Risks and Mitigation

### Risk 1: Breaking Existing Projects
**Mitigation**: Provide clear migration guide and backward compatibility

### Risk 2: Vendor Gem Updates
**Mitigation**: Document update process, use semantic versioning

### Risk 3: Path Resolution Issues
**Mitigation**: Robust path detection, clear error messages

### Risk 4: Symlink Support
**Mitigation**: Document OS requirements, provide alternatives

## Timeline

1. **Phase 1**: 1-2 hours - Move files, create initial symlinks
2. **Phase 2**: 2-3 hours - Implement symlink_build commands
3. **Phase 3**: 1 hour - Enhance init commands
4. **Phase 4**: 1-2 hours - Update documentation
5. **Testing**: 2-3 hours - Comprehensive testing

**Total**: 7-11 hours

## Success Criteria

- [ ] Steering files moved to vendor gems
- [ ] `symlink_build` command works in parent
- [ ] `symlink_build` command works in child
- [ ] `init` commands auto-create symlinks
- [ ] All existing symlinks still work
- [ ] Documentation updated
- [ ] Migration guide created
- [ ] Tests pass

## Related Documentation

- `.kiro/steering/submoduler_gem.md` - Base gem guide
- `.kiro/steering/submoduler_child.md` - Child gem guide
- `.kiro/steering/submodules_parent.md` - Parent gem guide
- `.kiro/steering/subgems_parent.md` - Subgem development guide
