# Design Document

## Overview

This design implements a Sinatra JSON-RPC demonstration consisting of two separate Sinatra applications: a server that handles JSON-RPC requests and a client that makes JSON-RPC calls through a web interface. The demo showcases proper JSON-RPC 2.0 protocol implementation, error handling, and various parameter types.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Sinatra JSON-RPC Demo                      │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    HTTP/JSON-RPC    ┌─────────────┐│
│  │   Client App    │◄──────────────────►│ Server App  ││
│  │   (Port 4568)   │                     │(Port 4567)  ││
│  │                 │                     │             ││
│  │ ┌─────────────┐ │                     │┌───────────┐││
│  │ │Web Interface│ │                     ││JSON-RPC   │││
│  │ │   Forms     │ │                     ││Processor  │││
│  │ └─────────────┘ │                     │└───────────┘││
│  │ ┌─────────────┐ │                     │┌───────────┐││
│  │ │JSON-RPC     │ │                     ││RPC Methods│││
│  │ │Client       │ │                     ││- calc     │││
│  │ │             │ │                     ││- string   │││
│  │ └─────────────┘ │                     ││- storage  │││
│  └─────────────────┘                     │└───────────┘││
│                                          └─────────────┘│
├─────────────────────────────────────────────────────────┤
│                   Technology Stack                       │
│  • Ruby + Sinatra                                       │
│  • JSON-RPC 2.0 Protocol                               │
│  • Net::HTTP for client requests                        │
│  • JSON parsing/generation                              │
│  • ERB templates for web interface                      │
└─────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. Server Application (server/)

**Purpose**: Handle JSON-RPC requests and provide RPC method implementations

**Structure**:
- `server/app.rb` - Main Sinatra application
- `server/rpc_methods.rb` - RPC method implementations
- `server/json_rpc_processor.rb` - JSON-RPC protocol handler
- `server/Gemfile` - Dependencies

**Key Classes**:
- `JsonRpcProcessor` - Handles JSON-RPC protocol compliance
- `RpcMethods` - Contains all available RPC methods
- `ServerApp` - Main Sinatra application class

### 2. Client Application (client/)

**Purpose**: Provide web interface for making JSON-RPC calls

**Structure**:
- `client/app.rb` - Main Sinatra application
- `client/json_rpc_client.rb` - JSON-RPC client implementation
- `client/views/` - ERB templates for web interface
- `client/public/` - Static assets (CSS, JS)
- `client/Gemfile` - Dependencies

**Key Classes**:
- `JsonRpcClient` - Handles JSON-RPC request generation and sending
- `ClientApp` - Main Sinatra application class

### 3. JSON-RPC Protocol Handler

**Purpose**: Ensure JSON-RPC 2.0 specification compliance

**Responsibilities**:
- Parse incoming JSON-RPC requests
- Validate request format and parameters
- Generate compliant responses and errors
- Handle both named and positional parameters

## Data Models

### JSON-RPC Request Format

```json
{
  "jsonrpc": "2.0",
  "method": "method_name",
  "params": {...},
  "id": 1
}
```

### JSON-RPC Response Format

```json
{
  "jsonrpc": "2.0",
  "result": {...},
  "id": 1
}
```

### JSON-RPC Error Format

```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32600,
    "message": "Invalid Request"
  },
  "id": null
}
```

### RPC Method Signatures

1. **Calculator Methods**:
   - `add(a, b)` - Returns sum of two numbers
   - `multiply(a, b)` - Returns product of two numbers
   - `divide(a, b)` - Returns division result with error handling

2. **String Methods**:
   - `reverse_string(text)` - Returns reversed string
   - `uppercase(text)` - Returns uppercased string
   - `word_count(text)` - Returns word count

3. **Storage Methods**:
   - `store_data(key, value)` - Stores key-value pair
   - `retrieve_data(key)` - Retrieves stored value
   - `list_keys()` - Returns all stored keys

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

Property 1: Valid JSON-RPC request processing
*For any* valid JSON-RPC 2.0 request, the server should return a properly formatted JSON-RPC 2.0 response with the correct structure and fields
**Validates: Requirements 1.3**

Property 2: Invalid JSON-RPC request error handling
*For any* invalid JSON-RPC request (malformed JSON, missing fields, invalid format), the server should return an appropriate JSON-RPC error response with proper error codes
**Validates: Requirements 1.4**

Property 3: Request and response logging
*For any* incoming JSON-RPC request, the server should create log entries for both the request and the corresponding response with timestamps
**Validates: Requirements 1.5, 6.1, 6.2**

Property 4: Client JSON-RPC request format compliance
*For any* RPC call made by the client, the generated request should be JSON-RPC 2.0 compliant with all required fields
**Validates: Requirements 2.3, 4.5**

Property 5: Client response display formatting
*For any* successful JSON-RPC response received by the client, the result should be displayed in a user-friendly format in the web interface
**Validates: Requirements 2.4**

Property 6: Client error handling and display
*For any* JSON-RPC error response received by the client, the error should be handled gracefully and displayed with meaningful messages
**Validates: Requirements 2.5, 6.5**

Property 7: RPC method parameter validation
*For any* RPC method call with invalid parameter types, the server should return appropriate JSON-RPC error responses before processing
**Validates: Requirements 3.4, 3.5**

Property 8: JSON-RPC protocol compliance
*For any* request processed by the server, the response should comply with JSON-RPC 2.0 specification including proper field names and structure
**Validates: Requirements 4.1, 4.3**

Property 9: Protocol violation error codes
*For any* JSON-RPC protocol violation, the server should return the correct JSON-RPC error code as specified in the JSON-RPC 2.0 specification
**Validates: Requirements 4.4**

Property 10: JSON parsing error handling
*For any* malformed JSON sent to the server, the server should return a proper JSON-RPC parse error response
**Validates: Requirements 6.4**

## Error Handling

### JSON-RPC Error Codes

The server implements standard JSON-RPC 2.0 error codes:

- `-32700` Parse error: Invalid JSON was received
- `-32600` Invalid Request: The JSON sent is not a valid Request object
- `-32601` Method not found: The method does not exist / is not available
- `-32602` Invalid params: Invalid method parameter(s)
- `-32603` Internal error: Internal JSON-RPC error
- `-32000 to -32099` Server error: Reserved for implementation-defined server-errors

### Error Handling Strategy

1. **Network Errors**: Client handles connection timeouts and network failures gracefully
2. **JSON Parsing Errors**: Server returns parse error responses for malformed JSON
3. **Method Validation**: Server validates method existence before parameter validation
4. **Parameter Validation**: Server validates parameter types and ranges before execution
5. **Internal Errors**: Server catches exceptions and returns internal error responses

## Testing Strategy

### Unit Testing

**RSpec Framework**: Use RSpec for comprehensive unit testing of both client and server components.

**Unit Test Coverage**:
- JSON-RPC protocol handler parsing and validation
- Individual RPC method implementations (calculator, string, storage)
- Client JSON-RPC request generation
- Error handling for various failure scenarios
- Logging functionality verification

**Test Structure**:
- `spec/server/` - Server application unit tests
- `spec/client/` - Client application unit tests
- `spec/shared/` - Shared test utilities and helpers

### Property-Based Testing

**Property-Based Testing Library**: Use RSpec with `rspec-parameterized` gem for property-based testing.

**Property Test Configuration**: Each property-based test runs a minimum of 100 iterations with randomly generated test data.

**Property Test Implementation**:
- Each property-based test includes a comment explicitly referencing the correctness property from this design document
- Test tags use format: '**Feature: sinatra-json-rpc-demo, Property {number}: {property_text}**'
- Each correctness property is implemented by a single property-based test

**Property Test Coverage**:
- Valid JSON-RPC request/response format compliance across random valid inputs
- Invalid request handling across various malformed inputs
- Parameter validation across different data types and ranges
- Error code correctness across different error conditions
- Logging verification across all request types

### Integration Testing

**End-to-End Testing**:
- Client-server communication flow testing
- Web interface functionality testing
- Error propagation from server to client UI
- Complete JSON-RPC call lifecycle testing

**Test Environment**:
- Separate test instances of client and server applications
- Mock network conditions for error testing
- Isolated test data storage for storage method testing

## Implementation Notes

### Technology Choices

1. **Sinatra Framework**: Lightweight Ruby web framework suitable for simple applications
2. **JSON Library**: Ruby's built-in JSON library for parsing and generation
3. **Net::HTTP**: Ruby's standard HTTP client library for client-server communication
4. **ERB Templates**: Embedded Ruby templates for client web interface
5. **Rack**: Web server interface for both applications

### Development Approach

1. **Server-First Development**: Implement server application and RPC methods first
2. **Protocol Compliance**: Ensure JSON-RPC 2.0 specification compliance throughout
3. **Error-Driven Development**: Implement comprehensive error handling early
4. **Test-Driven Development**: Write tests alongside implementation
5. **Documentation-Driven**: Maintain clear README and inline documentation

### Deployment Considerations

1. **Port Configuration**: Server on port 4567, client on port 4568 (configurable)
2. **Environment Variables**: Support for configuration via environment variables
3. **Logging Configuration**: Configurable log levels and output destinations
4. **Development vs Production**: Different configurations for development and production environments

### Security Considerations

1. **Input Validation**: Comprehensive validation of all input parameters
2. **Error Information**: Limit error message details to prevent information leakage
3. **Request Size Limits**: Implement reasonable limits on request payload sizes
4. **Rate Limiting**: Consider implementing basic rate limiting for production use