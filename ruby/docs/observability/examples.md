# Observability Examples

Concrete examples moved out of the topical `observability` guidance files to keep rule context small. Read this file only when a concrete implementation example is useful.

## Provider abstraction — example 1

Source topic: `providers-logging.md`

```ruby
class Observability::Errors
  def initialize(provider: default_provider)
    @provider = provider
  end

  def capture(exception, context: {})
    provider.capture(exception, context:)
  end

  private

  attr_reader :provider
end
```
