# Implementation Plan: Rails 8 Demo App

## Tasks

- [x] 1. Create Rails 8 application structure
  - Generate new Rails 8 app in `submodules/examples/rails8-demo`
  - Configure as git submodule
  - Set up SQLite database configuration
  - _Requirements: 1.1, 1.2, 1.4_

- [x] 2. Configure ActiveDataFlow dependencies
  - Add active_data_flow gem with path reference to parent
  - Add runtime-heartbeat gem with path reference
  - Add connector-source-active_record gem with path reference
  - Add connector-sink-active_record gem with path reference
  - Run bundle install
  - _Requirements: 1.3, 2.1_

- [x] 3. Create database models and migrations
  - [x] 3.1 Create Product model and migration
    - Generate migration for products table with name, sku, price, category, active fields
    - Add unique index on sku
    - Create Product model class
    - _Requirements: 3.1, 6.1_
  
  - [x] 3.2 Create ProductExport model and migration
    - Generate migration for product_exports table with product_id, name, sku, price_cents, category_slug, exported_at fields
    - Add index on product_id
    - Create ProductExport model class
    - _Requirements: 3.3, 6.2_

- [x] 4. Implement ProductSyncFlow DataFlow
  - [x] 4.1 Create DataFlow class
    - Create app/data_flows directory
    - Implement ProductSyncFlow class inheriting from ActiveDataFlow::DataFlow
    - Configure ActiveRecord source connector with Product model and active scope
    - Configure ActiveRecord sink connector with ProductExport model
    - _Requirements: 2.2, 3.1, 3.2, 2.4_
  
  - [x] 4.2 Implement transformation logic
    - Create transform method to convert Product data to ProductExport format
    - Convert price to price_cents (multiply by 100)
    - Generate category_slug from category using parameterize
    - Add exported_at timestamp
    - _Requirements: 3.2, 6.3_
  
  - [x] 4.3 Implement run method with error handling
    - Iterate through source messages
    - Transform each message
    - Write to sink
    - Handle errors gracefully with logging
    - _Requirements: 3.5, 6.5_

- [x] 5. Configure ActiveDataFlow Rails engine
  - [x] 5.1 Create initializer
    - Create config/initializers/active_data_flow.rb
    - Configure authentication_enabled = false for demo
    - Configure ip_whitelisting_enabled = false for demo
    - Configure heartbeat runtime settings
    - _Requirements: 2.1, 2.3_
  
  - [x] 5.2 Mount engine in routes
    - Mount ActiveDataFlow::RailsHeartbeatApp::Engine at /active_data_flow
    - Add root route to products#index
    - Add resources for products and product_exports
    - _Requirements: 2.1, 4.1_

- [x] 6. Create controllers and views
  - [x] 6.1 Create ProductsController
    - Implement index action to list all products
    - Implement show action for product details
    - Create corresponding views
    - _Requirements: 4.1, 4.2_
  
  - [x] 6.2 Create ProductExportsController
    - Implement index action to list all product exports
    - Show export status and timestamps
    - Create corresponding views
    - _Requirements: 4.1, 4.2_

- [x] 7. Create seed data
  - [x] 7.1 Add sample products
    - Create 10-15 sample products with varied data
    - Include both active and inactive products
    - Include different categories
    - _Requirements: 1.5, 6.1_
  
  - [x] 7.2 Seed DataFlow configuration
    - Create ProductSyncFlow DataFlow record
    - Set enabled = true
    - Set run_interval = 60 seconds
    - Configure class_name and other settings
    - _Requirements: 2.2, 4.3_

- [x] 8. Create documentation
  - [x] 8.1 Write README.md
    - Document setup instructions (clone, bundle, db setup)
    - Document how to run the application
    - Document how to trigger DataFlows manually
    - Include troubleshooting section
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_
  
  - [x] 8.2 Add inline code documentation
    - Document ProductSyncFlow class and methods
    - Add comments explaining transformation logic
    - Document configuration options
    - _Requirements: 5.1_

- [x] 9. Set up git submodule
  - [x] 9.1 Initialize git repository
    - Initialize git in submodules/examples/rails8-demo
    - Create initial commit with generated Rails app
    - _Requirements: 1.2_
  
  - [x] 9.2 Configure parent repository
    - Add submodule reference in parent .gitmodules
    - Update parent repository to track submodule
    - Document submodule setup in parent README
    - _Requirements: 1.2_

- [ ]* 10. Create automated tests
  - [ ]* 10.1 Write DataFlow specs
    - Test ProductSyncFlow initialization
    - Test transformation logic
    - Test error handling
    - _Requirements: 3.5, 6.5_
  
  - [ ]* 10.2 Write integration specs
    - Test full pipeline from Product to ProductExport
    - Test filtering of inactive products
    - Test data transformation accuracy
    - _Requirements: 3.1, 3.2, 3.3, 6.2, 6.3_
  
  - [ ]* 10.3 Write controller specs
    - Test ProductsController actions
    - Test ProductExportsController actions
    - Test routing
    - _Requirements: 4.1, 4.2_

- [ ]* 11. Add additional example DataFlows
  - [ ]* 11.1 Create error handling example
    - Implement DataFlow that demonstrates error recovery
    - Show how to handle validation errors
    - _Requirements: 6.4_
  
  - [ ]* 11.2 Create batch processing example
    - Implement DataFlow with batch operations
    - Demonstrate performance patterns
    - _Requirements: 6.4_
