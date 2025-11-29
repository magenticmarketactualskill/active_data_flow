## Gem Steering Integration

This project uses submodules and vendor gems that provide their own steering rules. These rules are automatically symlinked into the parent project's `.kiro/steering` directory.

### How It Works

- Vendor gems (in `vendor/`) may contain `.kiro/steering/*.md` files with steering rules
- Submodules (in `submodules/`) may contain `.kiro/steering/*.md` files with steering rules
- These files are symlinked into the parent project's `.kiro/steering` directory
- Symlinks allow gems to provide context and guidelines that are automatically available to Kiro

### Managing Symlinks

To rebuild symlinks from vendor gems to the parent `.kiro/steering` directory:

```bash
bin/gem_steering.rb symlink_build
```

This command will:
- Create symlinks for new steering files from all (prefer version in vendor folder) gems
- Update / delete existing symlinks if sources have changed
- Skip files that already exist as regular files (not symlinks)
- Report broken symlinks

### Current Sources

Steering files are sourced from:
- `vendor/submoduler_parent/.kiro/steering/` - Parent gem steering rules
- `vendor/submoduler_child/.kiro/steering/` - Child gem steering rules
- Submodules create their own symlinks to parent steering files

### Note

The `.kiro/gem_steering/` directory is reserved for future use to store gem-specific steering metadata.