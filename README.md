# ActiveDataFlow

ActiveDataFlow is a Ruby Gem that implements a Rails Engine (`DataFlowEngine`) for managing data flow configurations with seamless AWS service integration.

## Features

- **Rails Engine Architecture**: Mounts as a Rails Engine with configurable base route
- **DataFlow Objects**: Define data flows as Ruby classes with controller-like functionality
- **Automatic Routing**: Each DataFlow object automatically creates its own route
- **Database Configuration Storage**: Persistent storage of data flow configurations
- **AWS Service Integration**: 
  - AWS Lambda (with Ruby, Go, and Rust support)
  - Amazon MSK (Managed Streaming for Apache Kafka)
  - AWS CloudFormation
  - Amazon ECR (Elastic Container Registry)
  - Amazon API Gateway
- **Bidirectional Sync**: Push configurations to AWS and pull from AWS
- **Multi-Language Lambda Support**: Write Lambda functions in Ruby, Go, or Rust

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_data_flow'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install active_data_flow
```

Run the migrations:

```bash
$ rails active_data_flow:install:migrations
$ rails db:migrate
```

## Configuration

Create an initializer `config/initializers/active_data_flow.rb`:

```ruby
ActiveDataFlow.configure do |config|
  config.aws_region = 'us-east-1'
  config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.base_route = '/dataflow'
  config.enable_ui = true
end
```

## Usage

### Creating a DataFlow Object

Create a new DataFlow object in `app/data_flow/`:

```ruby
# app/data_flow/user_registration_flow.rb
class UserRegistrationFlow < ActiveDataFlow::DataFlowBase
  configure do |config|
    config.description "Handles user registration events"
    
    config.lambda_function(
      code_language: 'ruby',
      runtime: 'ruby3.2',
      handler: 'handler.process',
      memory_size: 512,
      timeout: 30
    )
    
    config.kafka_topics ['user.registered', 'user.verified']
    
    config.api_gateway(
      api_name: 'UserRegistrationAPI',
      stage_name: 'production'
    )
  end

  def process
    # Your processing logic here
    { status: 'success', message: 'User registration processed' }
  end

  def status
    super
  end
end
```

This automatically creates the route: `/dataflow/user_registration_flow`

### Syncing with AWS

```ruby
# Push configuration to AWS
UserRegistrationFlow.push!

# Pull configuration from AWS
UserRegistrationFlow.pull!

# Check sync status
UserRegistrationFlow.data_flow_record.aws_sync_status
```

### Routes

The engine provides the following routes:

- `GET /dataflow` - List all data flows
- `GET /dataflow/:name` - Show specific data flow
- `POST /dataflow/:name/push` - Push configuration to AWS
- `POST /dataflow/:name/pull` - Pull configuration from AWS
- `POST /dataflow/:name/sync` - Sync with AWS
- `GET /dataflow/:name/status` - Get sync status

## Architecture

### Database Schema

- **data_flows**: Main configuration table
- **lambda_configurations**: Lambda function configurations
- **kafka_configurations**: MSK cluster and topic configurations
- **api_gateway_configurations**: API Gateway configurations

### AWS Integration

Each AWS service has a dedicated service class:

- `LambdaService`: Manages Lambda functions
- `KafkaService`: Manages MSK clusters and topics
- `CloudFormationService`: Manages infrastructure as code
- `EcrService`: Manages container images
- `ApiGatewayService`: Manages API endpoints

## Development

After checking out the repo, run:

```bash
$ bundle install
$ bundle exec rake db:migrate
```

Run the test suite:

```bash
$ bundle exec rspec
$ bundle exec cucumber
```

## Testing

ActiveDataFlow includes comprehensive test coverage with RSpec and Cucumber:

```bash
# Run RSpec tests
$ bundle exec rspec

# Run Cucumber features
$ bundle exec cucumber

# Run all tests
$ bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/activedataflow/active_data_flow.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
