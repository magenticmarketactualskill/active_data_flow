# Rails 8 Demo App Design

## Overview

A complete Rails 8 application demonstrating ActiveDataflow functionality, created as a git submodule. The app showcases a product catalog synchronization use case with data transformation.

See: `requirements.md` for detailed requirements
See: `../../glossary.md` for terminology

## Architecture

### Application Structure

```
submodules/examples/rails8-demo/
├── app/
│   ├── controllers/
│   ├── models/
│   │   ├── product.rb              # Source table
│   │   └── product_export.rb       # Sink table
│   ├── data_flows/
│   │   └── product_sync_flow.rb    # Example DataFlow
│   └── views/
├── config/
│   ├── routes.rb                   # Mount ActiveDataflow engine
│   └── initializers/
│       └── active_data_flow.rb     # Configure heartbeat
├── db/
│   ├── migrate/
│   │   ├── create_products.rb
│   │   └── create_product_exports.rb
│   └── seeds.rb                    # Sample data
└── README.md                       # Setup instructions
```

## Components

### 1. Rails 8 Application

**Framework**: Rails 8.0+
**Database**: SQLite (for simplicity)
**Ruby**: 2.7+

**Key Gems**:
- `rails` (~> 8.0)
- `active_data_flow` (path reference to parent)
- `active_data_flow-runtime-heartbeat` (path reference)
- `active_data_flow-connector-source-active_record` (path reference)
- `active_data_flow-connector-sink-active_record` (path reference)

### 2. Database Models

**Product** (source table):
```ruby
class Product < ApplicationRecord
  # Attributes: name, sku, price, category, active, created_at, updated_at
end
```

**ProductExport** (sink table):
```ruby
class ProductExport < ApplicationRecord
  # Attributes: product_id, name, sku, price_cents, category_slug, 
  #             exported_at, created_at, updated_at
end
```

### 3. Example DataFlow

**ProductSyncFlow**:
```ruby
class ProductSyncFlow < ActiveDataflow::DataFlow
  def initialize(config)
    super
    @source = ActiveDataflow::Connector::Source::ActiveRecord.new(
      model: Product,
      scope: ->(r) { r.where(active: true) }
    )
    @sink = ActiveDataflow::Connector::Sink::ActiveRecord.new(
      model: ProductExport
    )
  end

  def run
    @source.each do |message|
      transformed = transform(message.data)
      @sink.write(transformed)
    end
  end

  private

  def transform(data)
    {
      product_id: data['id'],
      name: data['name'],
      sku: data['sku'],
      price_cents: (data['price'] * 100).to_i,
      category_slug: data['category']&.parameterize,
      exported_at: Time.current
    }
  end
end
```

### 4. ActiveDataflow Configuration

**Initializer** (`config/initializers/active_data_flow.rb`):
```ruby
ActiveDataFlow::RailsHeartbeatApp.configure do |config|
  config.authentication_enabled = false  # Disabled for demo
  config.ip_whitelisting_enabled = false # Disabled for demo
end
```

**Routes** (`config/routes.rb`):
```ruby
Rails.application.routes.draw do
  mount ActiveDataFlow::RailsHeartbeatApp::Engine => "/active_data_flow"
  
  root "products#index"
  resources :products
  resources :product_exports, only: [:index]
end
```

### 5. DataFlow Configuration

**Seed DataFlow** (`db/seeds.rb`):
```ruby
ActiveDataFlow::RailsHeartbeatApp::DataFlow.create!(
  name: "Product Sync Flow",
  enabled: true,
  run_interval: 60,  # Run every 60 seconds
  configuration: {
    class_name: "ProductSyncFlow"
  }
)
```

### 6. User Interface

**Pages**:
1. **Products Index** (`/products`) - View source products
2. **Product Exports Index** (`/product_exports`) - View exported products
3. **DataFlows Dashboard** (`/active_data_flow/data_flows`) - Manage DataFlows
4. **Heartbeat Endpoint** (`POST /active_data_flow/data_flows/heartbeat`) - Trigger execution

**Features**:
- View products and their export status
- Manually trigger DataFlow execution
- View execution history and errors
- Monitor DataFlow status

## Use Case: Product Catalog Sync

### Scenario

An e-commerce platform needs to sync product data from the main catalog to an export table for external systems. The sync includes:
- Filtering active products only
- Converting price to cents
- Generating category slugs
- Adding export timestamp

### Data Flow

```
Products Table (source)
  ↓ Filter: active = true
  ↓ Transform: price → price_cents, category → slug
  ↓ Add: exported_at timestamp
ProductExports Table (sink)
```

### Demonstration Steps

1. **Setup**: Create products via Rails console or UI
2. **Configure**: DataFlow already seeded
3. **Trigger**: POST to heartbeat endpoint or wait for interval
4. **Verify**: Check product_exports table
5. **Monitor**: View execution history in UI

## Database Schema

### products

```ruby
create_table :products do |t|
  t.string :name, null: false
  t.string :sku, null: false, index: { unique: true }
  t.decimal :price, precision: 10, scale: 2, null: false
  t.string :category
  t.boolean :active, default: true
  t.timestamps
end
```

### product_exports

```ruby
create_table :product_exports do |t|
  t.integer :product_id, null: false, index: true
  t.string :name, null: false
  t.string :sku, null: false
  t.integer :price_cents, null: false
  t.string :category_slug
  t.datetime :exported_at, null: false
  t.timestamps
end
```

## Setup Instructions

### 1. Clone with Submodules

```bash
git clone --recursive https://github.com/yourusername/active_data_flow.git
cd active_data_flow/submodules/examples/rails8-demo
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Setup Database

```bash
rails db:create db:migrate db:seed
```

### 4. Start Server

```bash
rails server
```

### 5. Trigger DataFlow

```bash
# Via curl
curl -X POST http://localhost:3000/active_data_flow/data_flows/heartbeat

# Or visit in browser
open http://localhost:3000
```

## Testing Strategy

### Manual Testing
- Create products via UI
- Trigger DataFlow via heartbeat
- Verify exports created
- Check execution history

### Automated Testing
- RSpec tests for DataFlow logic
- Integration tests for full pipeline
- Controller tests for UI

## Error Handling

### DataFlow Errors
- Logged to DataFlowRun records
- Displayed in UI
- Doesn't prevent other flows from running

### Database Errors
- Handled by connectors
- Raised as IOError
- Captured in execution history

## Future Enhancements

- Multiple DataFlow examples
- Different connector types
- Scheduled execution examples
- Error recovery patterns
- Performance monitoring

## File Structure

```
submodules/examples/rails8-demo/
├── app/
│   ├── controllers/
│   │   ├── products_controller.rb
│   │   └── product_exports_controller.rb
│   ├── models/
│   │   ├── product.rb
│   │   └── product_export.rb
│   ├── data_flows/
│   │   └── product_sync_flow.rb
│   └── views/
│       ├── products/
│       └── product_exports/
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── initializers/
│       └── active_data_flow.rb
├── db/
│   ├── migrate/
│   │   ├── 001_create_products.rb
│   │   └── 002_create_product_exports.rb
│   ├── seeds.rb
│   └── schema.rb
├── .kiro/
│   ├── specs/
│   │   ├── requirements.md
│   │   └── design.md (this file)
│   └── steering/ (symlinks to parent)
├── Gemfile
├── README.md
└── .git/ (separate repository)
```

## Related Documentation

- Parent Requirements: `../../requirements.md`
- Parent Design: `../../design.md`
- Rails Engine: `../../steering/rails.rb`
