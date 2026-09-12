# Namespaces

Detailed guidance referenced by `docs/ruby.md`. Read this file only when this topic is relevant to the task.

## Namespaces

Prefer compact namespace declarations when parent namespaces already exist.

Use:

```ruby
class A::B::C
  def call
  end
end
```

Do not prefer:

```ruby
module A
  module B
    class C
      def call
      end
    end
  end
end
```

Likewise, prefer:

```ruby
module A::B
end
```

over nested module declarations when the parent namespaces already exist.

---
