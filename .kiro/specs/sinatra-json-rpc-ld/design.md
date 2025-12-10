# Design Document

## Overview

This design implements a Sinatra JSON-RPC-LD demonstration that extends traditional JSON-RPC with JSON-LD (Linked Data) capabilities. The system consists of two Sinatra applications: a server that processes JSON-RPC requests with semantic JSON-LD payloads, and a client that provides a web interface for making semantic RPC calls. The design leverages standard vocabularies like schema.org, GeoSPARQL, and Good Relations to demonstrate real-world semantic data interchange.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Web Browser                          │
│                 (User Interface)                        │
└─────────────────┬───────────────────────────────────────┘
                  │ HTTP Requests
                  ▼
┌─────────────────────────────────────────────────────────┐
│              Client Application                         │
│                (Port 4568)                              │
│  ┌────────────┐  ┌────────────┐  ┌──────────────────┐  │
│  │   Web UI   │  │JSON-RPC-LD │  │   JSON-LD        │  │
│  │  Routes    │  │  Client    │  │  Builder         │  │
│  └────────────┘  └────────────┘  └──────────────────┘  │
└─────────────────┬───────────────────────────────────────┘
                  │ JSON-RPC-LD Requests
                  ▼
┌─────────────────────────────────────────────────────────┐
│              Server Application                         │
│                (Port 4567)                              │
│  ┌────────────┐  ┌────────────┐  ┌──────────────────┐  │
│  │JSON-RPC-LD │  │ Semantic   │  │   Vocabulary     │  │
│  │ Processor  │  │ Validator  │  │   Manager        │  │
│  └────────────┘  └────────────┘  └──────────────────┘  │
│  ┌────────────┐  ┌────────────┐  ┌──────────────────┐  │
│  │    RPC     │  │  Context   │  │     Logger       │  │
│  │  Methods   │  │  Manager   │  │                  │  │
│  └────────────┘  └────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Technology Stack

- **Ruby**: 3.0+
- **Sinatra**: Web framework for both client and server
- **JSON-LD**: Ruby gem for JSON-LD processing
- **RDF**: Ruby gem for RDF data handling
- **HTTParty**: HTTP client for JSON-RPC requests
- **ERB**: Templating for client web interface

## Components and Interfaces

### 1. Server Application Components

#### 1.1 JSON-RPC-LD Processor
**Purpose**: Handle JSON-RPC protocol with JSON-LD payload validation

**Responsibilities**:
- Parse incoming JSON-RPC requests
- Validate JSON-LD structure and context
- Route requests to appropriate RPC methods
- Format responses with JSON-LD context

**Interface**:
```ruby
class JsonRpcLdProcessor
  def process_request(request_body)
  def validate_jsonld(payload)
  def format_response(result, context)
  def format_error(error_code, message, data = nil)
end
```

#### 1.2 Semantic Validator
**Purpose**: Validate JSON-LD data against vocabularies and contexts

**Responsibilities**:
- Validate JSON-LD syntax and structure
- Check vocabulary compliance
- Verify context references
- Provide detailed validation errors

**Interface**:
```ruby
class SemanticValidator
  def validate_structure(jsonld_data)
  def validate_vocabulary(data, vocabulary_type)
  def validate_context(context_url_or_inline)
end
```

#### 1.3 Vocabulary Manager
**Purpose**: Manage and serve JSON-LD contexts and vocabularies

**Responsibilities**:
- Store and serve JSON-LD contexts
- Provide vocabulary definitions
- Handle context resolution
- Support multiple vocabulary types

**Interface**:
```ruby
class VocabularyManager
  def get_context(vocabulary_type)
  def resolve_context_url(url)
  def validate_against_vocabulary(data, vocabulary)
end
```

#### 1.4 RPC Methods
**Purpose**: Implement business logic for semantic RPC operations

**Methods**:
- `manage_person`: Handle person data with schema.org vocabulary
- `manage_product`: Handle product data with Good Relations vocabulary
- `manage_location`: Handle location data with GeoSPARQL vocabulary

### 2. Client Application Components

#### 2.1 JSON-RPC-LD Client
**Purpose**: Make JSON-RPC requests with JSON-LD payloads

**Responsibilities**:
- Construct JSON-RPC-LD requests
- Handle HTTP communication
- Parse JSON-LD responses
- Manage error handling

**Interface**:
```ruby
class JsonRpcLdClient
  def call_method(method_name, params_with_context)
  def build_request(method, params, context)
  def parse_response(response)
end
```

#### 2.2 JSON-LD Builder
**Purpose**: Construct JSON-LD payloads for different vocabularies

**Responsibilities**:
- Build schema.org person objects
- Build Good Relations product objects
- Build GeoSPARQL location objects
- Add appropriate contexts

**Interface**:
```ruby
class JsonLdBuilder
  def build_person(name, email, organization)
  def build_product(name, price, description)
  def build_location(latitude, longitude, address)
end
```

## Data Models

### JSON-LD Context Definitions

#### Schema.org Person Context
```json
{
  "@context": {
    "@vocab": "http://schema.org/",
    "Person": "Person",
    "name": "name",
    "email": "email",
    "worksFor": "worksFor",
    "Organization": "Organization"
  }
}
```

#### Good Relations Product Context
```json
{
  "@context": {
    "@vocab": "http://purl.org/goodrelations/v1#",
    "Product": "ProductOrService",
    "name": "name",
    "price": "hasPriceSpecification",
    "description": "description",
    "PriceSpecification": "PriceSpecification",
    "hasCurrencyValue": "hasCurrencyValue"
  }
}
```

#### GeoSPARQL Location Context
```json
{
  "@context": {
    "@vocab": "http://www.opengis.net/ont/geosparql#",
    "geo": "http://www.w3.org/2003/01/geo/wgs84_pos#",
    "Place": "Feature",
    "geometry": "hasGeometry",
    "lat": "geo:lat",
    "long": "geo:long",
    "address": "http://schema.org/address"
  }
}
```

### Example JSON-RPC-LD Request
```json
{
  "jsonrpc": "2.0",
  "method": "manage_person",
  "params": {
    "@context": {
      "@vocab": "http://schema.org/",
      "Person": "Person",
      "name": "name",
      "email": "email"
    },
    "@type": "Person",
    "name": "John Doe",
    "email": "john@example.com",
    "worksFor": {
      "@type": "Organization",
      "name": "Example Corp"
    }
  },
  "id": 1
}
```

### Example JSON-RPC-LD Response
```json
{
  "jsonrpc": "2.0",
  "result": {
    "@context": {
      "@vocab": "http://schema.org/",
      "Person": "Person",
      "identifier": "identifier"
    },
    "@type": "Person",
    "identifier": "person_123",
    "name": "John Doe",
    "email": "john@example.com",
    "worksFor": {
      "@type": "Organization",
      "name": "Example Corp"
    },
    "dateCreated": "2024-12-10T10:30:00Z"
  },
  "id": 1
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

Property 1: Valid JSON-RPC-LD requests receive proper responses
*For any* valid JSON-RPC-LD request with proper context, the server should return a JSON-RPC response containing JSON-LD data with appropriate context
**Validates: Requirements 1.3**

Property 2: Invalid JSON-RPC-LD requests receive semantic error responses
*For any* invalid JSON-RPC-LD request, the server should return a JSON-RPC error response with semantic error information
**Validates: Requirements 1.4**

Property 3: JSON-LD structure validation occurs for all requests
*For any* incoming request, the server should validate JSON-LD context and structure before processing
**Validates: Requirements 1.5**

Property 4: Client RPC calls are properly formatted
*For any* RPC call triggered by a user, the client should send a properly formatted JSON-RPC-LD request with appropriate context
**Validates: Requirements 2.3**

Property 5: Client response parsing preserves semantic information
*For any* response received by the client, JSON-LD data should be parsed and semantic information displayed appropriately
**Validates: Requirements 2.4**

Property 6: Client error handling includes semantic context
*For any* RPC call failure, the client should display meaningful error messages including semantic validation failures
**Validates: Requirements 2.5**

Property 7: Missing context triggers semantic error responses
*For any* RPC method receiving data without proper JSON-LD context, the server should return appropriate semantic error responses
**Validates: Requirements 3.4**

Property 8: Vocabulary compliance validation occurs before processing
*For any* data processing, the server should validate JSON-LD structure and vocabulary compliance before proceeding
**Validates: Requirements 3.5**

Property 9: JSON-RPC 2.0 protocol compliance with JSON-LD enhancement
*For any* request or response, the server should implement JSON-RPC 2.0 specification enhanced with JSON-LD context handling
**Validates: Requirements 4.1**

Property 10: JSON-LD context support in requests and responses
*For any* request parameter or response result, the server should support JSON-LD contexts appropriately
**Validates: Requirements 4.2**

Property 11: Dual protocol validation occurs for all requests
*For any* request processing, the server should validate both JSON-RPC protocol and JSON-LD structure compliance
**Validates: Requirements 4.3**

Property 12: Proper error codes for all violation types
*For any* protocol violation or semantic validation failure, the server should return proper error codes
**Validates: Requirements 4.4**

Property 13: Client generates compliant JSON-RPC-LD requests
*For any* client request, it should be JSON-RPC 2.0 compliant with valid JSON-LD payloads
**Validates: Requirements 4.5**

Property 14: Incoming data validation against declared contexts
*For any* incoming JSON-LD data, the server should validate it against declared contexts
**Validates: Requirements 5.2**

Property 15: Context preservation during semantic data processing
*For any* semantic data processing, the server should preserve and enhance JSON-LD context information
**Validates: Requirements 5.3**

Property 16: Support for both inline and URL contexts
*For any* context handling, the server should support both inline contexts and context references via URLs
**Validates: Requirements 5.4**

Property 17: Client constructs proper JSON-LD payloads
*For any* client request, JSON-LD payloads should be properly constructed with appropriate context declarations
**Validates: Requirements 5.5**

Property 18: Request logging includes semantic context
*For any* incoming JSON-RPC-LD request, the server should log it with semantic context information and timestamps
**Validates: Requirements 7.1**

Property 19: Response logging includes validation results
*For any* outgoing response, the server should log it with JSON-LD structure validation results
**Validates: Requirements 7.2**

Property 20: Semantic validation errors include detailed information
*For any* semantic validation error, the server should return JSON-RPC errors with detailed JSON-LD validation information
**Validates: Requirements 7.3**

Property 21: JSON-LD parsing errors include semantic details
*For any* JSON-LD parsing error, the server should return proper JSON-RPC error responses with semantic error details
**Validates: Requirements 7.4**

Property 22: Vocabulary-specific validation against constraints
*For any* vocabulary-specific data processing, the server should validate against vocabulary constraints
**Validates: Requirements 8.4**

<function_calls>
<invoke name="prework">
<parameter name="featureName">sinatra-json-rpc-ld

## Error Handling

### JSON-RPC Error Codes
- `-32700`: Parse error (invalid JSON)
- `-32600`: Invalid Request (invalid JSON-RPC)
- `-32601`: Method not found
- `-32602`: Invalid params
- `-32603`: Internal error
- `-32000` to `-32099`: Server error (reserved for implementation-defined server-errors)

### JSON-LD Specific Error Codes
- `-32100`: Invalid JSON-LD context
- `-32101`: JSON-LD structure validation failed
- `-32102`: Vocabulary compliance violation
- `-32103`: Context resolution failed
- `-32104`: Semantic validation error

### Error Response Format
```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32101,
    "message": "JSON-LD structure validation failed",
    "data": {
      "@context": {
        "@vocab": "http://www.w3.org/ns/json-ld#",
        "ValidationError": "ValidationError"
      },
      "@type": "ValidationError",
      "field": "@context",
      "expectedType": "object",
      "actualType": "string",
      "details": "Context must be an object or array of objects"
    }
  },
  "id": 1
}
```

### Error Handling Strategy

1. **JSON Parsing Errors**: Return standard JSON-RPC parse error
2. **JSON-RPC Protocol Errors**: Return standard JSON-RPC protocol errors
3. **JSON-LD Structure Errors**: Return semantic validation errors with JSON-LD context
4. **Vocabulary Validation Errors**: Return detailed vocabulary compliance errors
5. **Context Resolution Errors**: Return context-specific error information

## Testing Strategy

### Unit Testing Framework
- **RSpec**: Primary testing framework for Ruby components
- **WebMock**: Mock HTTP requests for testing client-server communication
- **JSON-LD Test Suite**: Validate JSON-LD processing compliance

### Property-Based Testing Framework
- **RSpec/QuickCheck**: Property-based testing library for Ruby
- **Minimum iterations**: 100 per property test
- **Custom generators**: Generate valid/invalid JSON-RPC-LD requests

### Unit Testing Approach

**Server Components**:
- Test JSON-RPC-LD processor with various request formats
- Test semantic validator with different vocabulary types
- Test vocabulary manager context resolution
- Test RPC methods with valid/invalid semantic data

**Client Components**:
- Test JSON-RPC-LD client request construction
- Test JSON-LD builder for different vocabularies
- Test response parsing and error handling
- Test web interface form handling

**Integration Testing**:
- Test complete client-server communication flow
- Test error propagation from server to client
- Test context resolution across network boundaries
- Test vocabulary validation end-to-end

### Property-Based Testing Approach

Each correctness property will be implemented as a property-based test with the following format:
- **Feature: sinatra-json-rpc-ld, Property {number}: {property_text}**
- Tests will run a minimum of 100 iterations
- Custom generators will create valid/invalid JSON-RPC-LD data
- Tests will verify universal properties across all valid inputs

### Test Data Generation

**JSON-RPC-LD Request Generator**:
- Generate valid JSON-RPC 2.0 structure
- Add valid JSON-LD contexts for different vocabularies
- Create invalid variations for error testing

**Vocabulary Data Generators**:
- Schema.org person/organization data
- Good Relations product data
- GeoSPARQL location data
- Mixed vocabulary combinations

**Context Generators**:
- Inline context objects
- Context URL references
- Invalid context structures
- Missing context scenarios

## Implementation Notes

### Directory Structure
```
submodules/examples/sinatra-json-rpc-ld/
├── server/
│   ├── app.rb                    # Main server application
│   ├── json_rpc_ld_processor.rb  # JSON-RPC-LD protocol handler
│   ├── semantic_validator.rb     # JSON-LD validation
│   ├── vocabulary_manager.rb     # Context and vocabulary management
│   ├── rpc_methods.rb           # Semantic RPC method implementations
│   ├── contexts/                # JSON-LD context definitions
│   │   ├── schema_org.json      # Schema.org contexts
│   │   ├── good_relations.json  # Good Relations contexts
│   │   └── geosparql.json       # GeoSPARQL contexts
│   └── Gemfile                  # Server dependencies
├── client/
│   ├── app.rb                   # Main client application
│   ├── json_rpc_ld_client.rb    # JSON-RPC-LD client
│   ├── json_ld_builder.rb       # JSON-LD payload construction
│   ├── views/                   # ERB templates
│   │   ├── layout.erb           # Base layout
│   │   ├── index.erb            # Home page
│   │   ├── person.erb           # Person management forms
│   │   ├── product.erb          # Product management forms
│   │   └── location.erb         # Location management forms
│   ├── public/
│   │   └── style.css            # CSS styling
│   └── Gemfile                  # Client dependencies
├── README.md                    # Setup and usage instructions
├── install_dependencies.sh      # Dependency installation
├── start_server.sh              # Start JSON-RPC-LD server
├── start_client.sh              # Start web client
├── start_demo.sh                # Start both applications
└── test_demo.sh                 # Test server functionality
```

### Key Dependencies

**Server**:
- `sinatra`: Web framework
- `json-ld`: JSON-LD processing
- `rdf`: RDF data handling
- `logger`: Request/response logging

**Client**:
- `sinatra`: Web framework
- `httparty`: HTTP client
- `json-ld`: JSON-LD construction
- `erb`: Template rendering

### Configuration

**Server Configuration**:
- Port: 4567
- JSON-RPC endpoint: `/jsonrpc`
- Context serving endpoint: `/contexts/{vocabulary}`
- Logging level: INFO

**Client Configuration**:
- Port: 4568
- Server URL: `http://localhost:4567/jsonrpc`
- Request timeout: 30 seconds
- Error display: User-friendly format

### Vocabulary Integration

**Schema.org Integration**:
- Person and Organization types
- Standard properties (name, email, worksFor)
- Validation against schema.org constraints

**Good Relations Integration**:
- Product and PriceSpecification types
- E-commerce properties (price, description)
- Currency and pricing validation

**GeoSPARQL Integration**:
- Feature and Geometry types
- Geographic coordinates (lat/long)
- Spatial relationship support