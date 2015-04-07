# Extensions

You can extend Halogen by configuring it to include your own Ruby modules.

For instance, if you wanted to cache the rendered versions of your
representers, you might use something like this to override the default
`#render` behavior:

```ruby
module MyCachingExtension
  def render
    Rails.cache.fetch(cache_key) { super }
  end

  def cache_key
    ...
  end
end
```

```ruby
Halogen.configure do |config|
  config.extensions << MyCachingExtension
end
```
