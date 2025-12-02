# Redcord Migration Guide

## Quick Reference: Redcord Model Patterns

### Correct Pattern (Redcord 0.2.2+)

```ruby
# typed: false
require 'sorbet-runtime'

class MyModel < T::Struct
  include Redcord::Base

  # Required fields
  attribute :name, String, index: true
  attribute :status, String, index: true
  
  # Optional fields (use T.nilable)
  attribute :description, T.nilable(String)
  attribute :count, T.nilable(Integer)
  
  # Timestamps (automatically added by Redcord)
  # created_at, updated_at
end
```

### Common Mistakes

❌ **Wrong: Plain Ruby class**
```ruby
class MyModel
  include Redcord::Base
end
```

✅ **Correct: Inherit from T::Struct**
```ruby
class MyModel < T::Struct
  include Redcord::Base
end
```

---

❌ **Wrong: Symbol types**
```ruby
attribute :name, :string
```

✅ **Correct: Class types**
```ruby
attribute :name, String
```

---

❌ **Wrong: Separate range_index**
```ruby
attribute :created_at, Integer
range_index :created_at
```

✅ **Correct: index option**
```ruby
attribute :created_at, Integer, index: true
```

---

❌ **Wrong: ActiveRecord validations**
```ruby
validates :name, presence: true
```

✅ **Correct: Type safety via Sorbet**
```ruby
attribute :name, String  # Cannot be nil
attribute :optional, T.nilable(String)  # Can be nil
```

## Type Reference

| Ruby Type | Redcord Type | Index Type |
|-----------|--------------|------------|
| String | `String` | Set index |
| Integer | `Integer` | Range index |
| Float | `Float` | Range index |
| Time | `Time` | Range index |
| Boolean | `T::Boolean` | Set index |
| Optional | `T.nilable(Type)` | Based on Type |

## Migration Checklist

- [ ] Add `gem 'redcord', '~> 0.2.2'` to Gemfile
- [ ] Run `bundle install`
- [ ] Update model to inherit from `T::Struct`
- [ ] Add `require 'sorbet-runtime'` at top
- [ ] Convert attribute types from symbols to classes
- [ ] Wrap optional fields with `T.nilable()`
- [ ] Replace `range_index` with `index: true` option
- [ ] Remove ActiveRecord-style validations
- [ ] Test CRUD operations

## Resources

- Redcord GitHub: https://github.com/chanzuckerberg/redcord
- Sorbet Docs: https://sorbet.org/
- ActiveDataFlow Storage Backends: `docs/storage_backends.md`
