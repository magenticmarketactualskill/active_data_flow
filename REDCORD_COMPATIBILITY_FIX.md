# Redcord Compatibility Fix

## Problem

The ActiveDataFlow Redcord models were incompatible with Redcord 0.2.2 due to incorrect implementation patterns. The models were using plain Ruby classes with `include Redcord::Base`, but Redcord requires models to inherit from `T::Struct` (Sorbet's typed struct).

### Specific Issues

1. **Type Error**: `Expected type T.class_of(T::Struct), got ActiveDataFlow::Redcord::DataFlow`
   - Redcord models must inherit from `T::Struct`, not plain Ruby classes
   
2. **NoMethodError**: `undefined method 'range_index'`
   - Redcord doesn't have a separate `range_index` method
   - Indexes are defined using `index: true` option on attributes
   
3. **NoMethodError**: `undefined method 'validates'`
   - Redcord doesn't support ActiveRecord-style validations
   - Type safety is enforced through Sorbet type annotations

## Solution

Updated both Redcord models to follow the correct Redcord/Sorbet patterns:

### Changes to `app/models/active_data_flow/redcord/data_flow.rb`

1. Added Sorbet runtime requirement and type annotation header
2. Changed from `class DataFlow` to `class DataFlow < T::Struct`
3. Updated attribute definitions:
   - Changed from `:string` symbols to `String` classes
   - Added `T.nilable()` wrapper for optional fields
   - Added `index: true` option for indexed attributes
4. Removed `range_index` calls (handled automatically by Redcord based on type)
5. Removed ActiveRecord-style `validates` calls

### Changes to `app/models/active_data_flow/redcord/data_flow_run.rb`

Applied the same pattern changes as DataFlow model.

## Implementation Details

### Before (Incorrect)

```ruby
module ActiveDataFlow
  module Redcord
    class DataFlow
      include ::Redcord::Base

      attribute :name, :string
      attribute :status, :string
      attribute :last_run_at, :integer
      
      range_index :name
      range_index :status
      
      validates :name, presence: true
    end
  end
end
```

### After (Correct)

```ruby
# typed: false
require 'sorbet-runtime'

module ActiveDataFlow
  module Redcord
    class DataFlow < T::Struct
      include ::Redcord::Base

      attribute :name, String, index: true
      attribute :status, String, index: true
      attribute :last_run_at, T.nilable(Integer)
      
      # No validates - type safety via Sorbet
    end
  end
end
```

## Key Differences

| Aspect | Old (Incorrect) | New (Correct) |
|--------|----------------|---------------|
| Class inheritance | Plain Ruby class | `< T::Struct` |
| Sorbet requirement | Not included | `require 'sorbet-runtime'` |
| Type annotation | `:string` symbols | `String` classes |
| Optional fields | `:string` | `T.nilable(String)` |
| Indexes | `range_index :field` | `attribute :field, Type, index: true` |
| Validations | `validates :field` | Removed (Sorbet handles types) |

## Testing

Created test scripts to verify compatibility:

1. **test_redcord_compatibility.rb** - Basic model loading test
2. **test_redcord_full.rb** - Full CRUD operations test (requires Redis)

Both tests pass successfully with Redcord 0.2.2.

## Dependencies

Added to Gemfile:
```ruby
gem 'redcord', '~> 0.2.2'
```

Redcord automatically includes:
- `sorbet-runtime` - For type checking
- `redis` - For Redis connectivity

## Benefits

1. **Type Safety**: Sorbet provides compile-time and runtime type checking
2. **Performance**: Proper Redcord usage enables optimized Redis operations
3. **Compatibility**: Works with current Redcord gem (0.2.2)
4. **Maintainability**: Follows official Redcord patterns and best practices

## Migration Notes

For existing applications using the old Redcord models:

1. Update Gemfile to include `gem 'redcord', '~> 0.2.2'`
2. Run `bundle install`
3. The models are backward compatible at the API level
4. Existing data in Redis remains accessible
5. No data migration required

## Status

✅ **RESOLVED** - All Redcord models are now fully compatible with Redcord 0.2.2 and ready for production use.

## References

- Redcord GitHub: https://github.com/chanzuckerberg/redcord
- Sorbet Documentation: https://sorbet.org/
- ActiveDataFlow Storage Backends: `docs/storage_backends.md`
