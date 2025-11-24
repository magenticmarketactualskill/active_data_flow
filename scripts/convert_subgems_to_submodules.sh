#!/bin/bash
# Script to convert subgems to submodules
# Prerequisites: GitHub repositories must be created first

set -e

echo "Converting subgems to submodules..."
echo ""

# Step 1: Initialize and push each subgem
echo "Step 1: Initializing and pushing subgems..."

cd subgems/active_data_flow-connector-sink-active_record
if [ ! -d .git ]; then
  git init
  git add -A
  git commit -m "Initial commit: ActiveRecord sink connector"
fi
git remote add origin https://github.com/magenticmarketactualskill/active_data_flow-connector-sink-active_record.git 2>/dev/null || true
git push -u origin main
cd ../..

cd subgems/active_data_flow-connector-source-active_record
if [ ! -d .git ]; then
  git init
  git add -A
  git commit -m "Initial commit: ActiveRecord source connector"
fi
git remote add origin https://github.com/magenticmarketactualskill/active_data_flow-connector-source-active_record.git 2>/dev/null || true
git push -u origin main
cd ../..

cd subgems/active_data_flow-runtime-heartbeat
if [ ! -d .git ]; then
  git init
  git add -A
  git commit -m "Initial commit: Heartbeat runtime"
fi
git remote add origin https://github.com/magenticmarketactualskill/active_data_flow-runtime-heartbeat.git 2>/dev/null || true
git push -u origin main
cd ../..

echo "✓ Subgems pushed to GitHub"
echo ""

# Step 2: Remove subgems from parent repo
echo "Step 2: Removing subgems from parent repo..."
git rm -r subgems/active_data_flow-connector-sink-active_record
git rm -r subgems/active_data_flow-connector-source-active_record
git rm -r subgems/active_data_flow-runtime-heartbeat
git commit -m "Remove subgems in preparation for submodule conversion"
echo "✓ Subgems removed"
echo ""

# Step 3: Add as submodules
echo "Step 3: Adding as submodules..."
git submodule add https://github.com/magenticmarketactualskill/active_data_flow-connector-sink-active_record.git submodules/active_data_flow-connector-sink-active_record

git submodule add https://github.com/magenticmarketactualskill/active_data_flow-connector-source-active_record.git submodules/active_data_flow-connector-source-active_record

git submodule add https://github.com/magenticmarketactualskill/active_data_flow-runtime-heartbeat.git submodules/active_data_flow-runtime-heartbeat

git submodule update --init --recursive
echo "✓ Submodules added"
echo ""

# Step 4: Update .submoduler.ini
echo "Step 4: Updating .submoduler.ini..."
cat > .submoduler.ini << 'EOF'
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
EOF
echo "✓ .submoduler.ini updated"
echo ""

# Step 5: Update Gemfile
echo "Step 5: Updating Gemfile..."
sed -i '' 's|subgems/|submodules/|g' Gemfile
echo "✓ Gemfile updated"
echo ""

# Step 6: Commit changes
echo "Step 6: Committing changes..."
git add .submoduler.ini .gitmodules Gemfile
git commit -m "Convert subgems to submodules"
echo "✓ Changes committed"
echo ""

echo "Conversion complete!"
echo ""
echo "Next steps:"
echo "1. Run: bundle install"
echo "2. Run: git push"
echo "3. Verify with: ruby vendor/submoduler_parent/bin/submoduler_parent.rb status"
