# Halogen

This library provides a framework-agnostic interface for generating
[HAL+JSON](http://stateless.co/hal_specification.html)
representations of resources in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'halogen'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install halogen

## Usage

### Basic usage

Create a simple representer class and include Halogen:

```ruby
class GoatRepresenter
  include Halogen

  property :name do
    'Gideon'
  end

  link :self do
    '/goats/gideon'
  end
end
```

Instantiate:

```ruby
repr = GoatRepresenter.new
```

Then call `repr.render`:

```ruby
{
  name: 'Gideon',
  _links: {
    self: { href: '/goats/gideon' }
  }
}
```

Or `repr.to_json`:

```ruby
'{"name": "Gideon", "_links": {"self": {"href": "/goats/gideon"}}}'
```

### Representer types

#### 1. Simple

Not associated with any particular resource or collection. For example, an API
entry point:

```ruby
class ApiRootRepresenter
  include Halogen

  link(:self) { '/api' }
end
```

#### 2. Resource

Represents a single item:

```ruby
class GoatRepresenter
  include Halogen

  resource :goat
end
```

When a resource is declared, `#initialize` expects the resource as the first argument:

```ruby
repr = GoatRepresenter.new(Goat.new, ...)
```

This makes property definitions cleaner:

```ruby
property :name # now calls Goat#name by default
```

#### 3. Collection

Represents a collection of items. When a collection is declared, the embedded
resource with the same name will always be embedded, whether it is requested
via standard embed options or not.

```ruby
class GoatKidsRepresenter
  include Halogen

  collection :kids

  embed(:kids) { ... } # always embedded
end
```

### Defining properties, links and embeds

Properties can be defined in several ways:

```ruby
property(:age) { "#{goat.age} years old" }
```

```ruby
property :age # => Goat#age, if resource is declared
```

```ruby
property :age do
  goat.age.round
end
```

```ruby
property(:age) { calculate_age }

def calculate_age
  ...
end
```

#### Conditionals

The inclusion of properties can be determined by conditionals using `if` and
`unless` options. For example, with a method name:

```ruby
property :age, if: :include_age?

def include_age?
  goat.age < 10
end
```

With a proc:
```ruby
property :age, unless: proc { goat.age.nil? }, value: ...
```

For links and embeds:

```ruby
link :kids, :templated, unless: :exclude_kids_link?, value: ...
```

```ruby
embed :kids, if: proc { goat.kids.size > 0 } do
  ...
end
```

#### Links

Simple link:

```ruby
link(:root) { '/' }
# => { _links: { root: { href: '/' } } ... }
```

Templated link:

```ruby
link(:find, :templated) { '/goats/{?id}' }
# => { _links: { find: { href: '/goats/{?id}', templated: true } } ... }
```

### Embedded resources

Embedded resources are not rendered by default. They will be included if both
of the following conditions are met:

1. The proc returns either a Halogen instance or an array of Halogen instances
2. The embed is requested via the parent representer's options, e.g.:

```ruby
GoatRepresenter.new(embed: { kids: true, parents: false })
```

Embedded resources can be nested to any depth, e.g.:

```ruby
GoatRepresenter.new(embed: {
  kids: {
    foods: {
      ingredients: true
    },
    pasture: true
  }
})
```

### Using with Rails

If Halogen is loaded in a Rails application, Rails url helpers will be
available in representers:

```ruby
link(:new) { new_goat_url }
```

### More examples

* [Full representer class](examples/simple.rb)
* [Extensions](examples/extensions.md)

### What's with the goat?

It is [majestic](https://twitter.com/ModeAnalytics/status/497876416013537280).

## Contributing

1. Fork it ( https://github.com/mode/halogen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
