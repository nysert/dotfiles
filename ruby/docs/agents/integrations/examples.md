# Integrations Examples

Concrete examples moved out of the topical `integrations` guidance files to keep rule context small. Read this file only when a concrete implementation example is useful.

## Stable provider interface — example 1

Source topic: `providers.md`

```ruby
class Messaging::Gateway
  def initialize(provider: default_provider)
    @provider = provider
  end

  def send_message(...)
    provider.send_message(...)
  end

  private

  attr_reader :provider
end
```
