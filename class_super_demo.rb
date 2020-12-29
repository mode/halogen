CALLS = 0

module Foo
  def render(thing)
    thing = thing + 1
    super(thing).merge(foo: thing)
  end
end

module Bar
  def render(thing)
    thing = thing + 1
    super(thing).merge(bar: thing)
  end
end

module Baz
  def render(thing)
    thing = thing + 1
    super(thing).merge(baz: thing)
  end
end

class FooThing
  module ClassMethods
    def render(thing)
      {}
    end
  end

  extend ClassMethods

  extend Foo
  extend Bar
  extend Baz
end