# Subgem to Submodule Conversion Guide

This document outlines the steps to convert subgems to proper git submodules.

## Repositories to Create on GitHub

Create these repositories on GitHub under `magenticmarketactualskill`:

1. `active_data_flow-connector-sink-active_record`
2. `active_data_flow-connector-source-active_record`
3. `active_data_flow-runtime-heartbeat`

## Conversion Steps

### 1. Initialize and Push Each Subgem

```bash
# Sink connector
cd subgems/active_data_flow-connector-sink-active_record
git init
git add -A
git commit -m "Initial commit: ActiveRecord sink connector"
git remote add origin https://github.com/magenticmarketactualskill/active_data_flow-connector-sink-active_record.git
git push -u origin main
cd ../..

# Source connector
cd subgems/active_data_flow-connector-source-active_record
git init
git add -A
git commit -m "Initial commit: ActiveRecord source connector"
git remote add origin https://github.com/magenticmarketactualskill/active_data_flow-connector-source-active_record.git
git push -u origin main
cd ../..

# Runtime heartbeat
cd subgems/active_data_flow-runtime-heartbeat
git init
git add -A
git commit -m "Initial commit: Heartbeat runtime"
git remote add origin https://github.com/magenticmarketactualskill/active_data_flow-runtime-heartbeat.git
git push -u origin main
cd ../..
```

### 2. Remove Subgems from Parent Repo

```bash
# Remove from git tracking
git rm -r subgems/active_data_flow-connector-sink-active_record
git rm -r subgems/active_data_flow-connector-source-active_record
git rm -r subgems/active_data_flow-runtime-heartbeat

# Commit the removal
git commit -m "Remove subgems in preparation for submodule conversion"
```

### 3. Add as Submodules

```bash
# Add each as a submodule
git submodule add https://github.com/magenticmarketactualskill/active_data_flow-connector-sink-active_record.git submodules/active_data_flow-connector-sink-active_record

git submodule add https://github.com/magenticmarketactualskill/active_data_flow-connector-source-active_record.git submodules/active_data_flow-connector-source-active_record

git submodule add https://github.com/magenticmarketactualskill/active_data_flow-runtime-heartbeat.git submodules/active_data_flow-runtime-heartbeat

# Initialize and update
git submodule update --init --recursive
```

### 4. Update .submoduler.ini

Replace `[subgem ...]` sections with `[submodule ...]` sections:

```ini
[default]
master = https://github.com/magenticmarketactualskill/active_data_flow.git

[submodule "submodules/active_data_flow-connector-sink-active_record"]
	path = submodules/active_data_flow-connector-sink-active_record
	url = https://github.com/magenticmarketactualskill/active_data_flow-connector-sink-active_record.git

[submodule "submodules/active_data_flow-connector-source-active_record"]
	path = submodules/active_data_flow-connector-source-active_record
	url = https://github.com/magenticmarketactualskill/active_data_flow-connector-source-active_record.git

[submodule "submodules/active_data_flow-runtime-heartbeat"]
	path = submodules/active_data_flow-runtime-heartbeat
	url = https://github.com/magenticmarketactualskill/active_data_flow-runtime-heartbeat.git

[submodule "submodules/examples/rails8-demo"]
	path = submodules/examples/rails8-demo
	url = https://github.com/magenticmarketactualskill/active_dataflow-examples-rails8-demo.git
```

### 5. Update Gemfile

Change path references from `subgems/` to `submodules/`:

```ruby
# Submodule path overrides for local development
gem 'active_data_flow-connector-source-active_record', path: 'submodules/active_data_flow-connector-source-active_record'
gem 'active_data_flow-connector-sink-active_record', path: 'submodules/active_data_flow-connector-sink-active_record'
gem 'active_data_flow-runtime-heartbeat', path: 'submodules/active_data_flow-runtime-heartbeat'
```

### 6. Update Documentation

Update all references from `subgems/` to `submodules/` in:
- README.md
- docs/structure.md
- Any other documentation

### 7. Commit and Push

```bash
git add .submoduler.ini .gitmodules Gemfile
git commit -m "Convert subgems to submodules"
git push
```

## Verification

After conversion, verify with:

```bash
# Check submodule status
git submodule status

# Check submoduler status
ruby vendor/submoduler_parent/bin/submoduler_parent.rb status

# Test bundle install
bundle install
```

## Benefits of Submodules

- Each component has its own git history
- Independent versioning and releases
- Cleaner separation of concerns
- Standard git submodule workflow
- Works with submoduler tooling
