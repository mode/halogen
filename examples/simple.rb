$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'halogen'
require 'pp'

# Example of a straightforward Halogen representer with no resource,
# collection, or conditional definitions
#
class GoatRepresenter
  include Halogen

  # Simple instance methods that will be used for properties below
  #
  def id;         1;        end
  def first_name; 'Gideon'; end
  def last_name;  'Goat';   end

  # == 1. Properties
  #
  # If you define a property without an explicit value or proc, Halogen will
  # look for a public instance method with the corresponding name.
  #
  # This will call GoatRepresenter#id.
  #
  property :id # => { id: 1 }

  # You can also define a property with an explicit value, e.g.:
  #
  property :age, value: 9.2 # => { age: 9.2 }

  # Or you can use a proc to determine the property value at render time.
  #
  # The example below could also be written: property(:full_name) { ... }
  #
  property :full_name do # => { full_name: 'Gideon Goat' }
    "#{first_name} #{last_name}"
  end

  # == 2. Links
  #
  # As with properties, links can be defined with a proc:
  #
  link :self do
    "/goats/#{id}" # => { self: { href: '/goats/1' } }
  end

  # ...Or with an explicit value:
  #
  link :root, value: '/goats' # => { root: { href: '/goats' } }

  # Links can also be defined as "templated", following HAL+JSON conventions:
  #
  link :find, :templated do # => ... { href: '/goats/{?id}', templated: true }
    '/goats/{?id}'
  end

  # If Halogen is loaded in a Rails application, url helpers will be available
  # automatically:
  #
  # link(:new) { new_goat_path }

  # == 3. Embeds
  #
  # Embedded resources are not rendered by default. They will be included if
  # both of the following conditions are met:
  #
  # 1. The proc returns either a Halogen instance or an array of Halogen instances
  # 2. The embed is requested via the parent representer's options, e.g.:
  #
  #      GoatRepresenter.new(embed: { kids: true, parents: false })
  #
  embed :kids do # => { kids: <GoatKidsRepresenter#render> }
    GoatKidsRepresenter.new
  end

  embed :parents do # => will not be included according to example options above
    [
      self.class.new,
      self.class.new
    ]
  end

  # Embedded resources can be nested to any depth, e.g.:
  #
  # GoatRepresenter.new(embed: {
  #   kids: {
  #     foods: {
  #       ingredients: true
  #     },
  #     enclosure: true
  #   }
  # })
end

# Another simple representer to demonstrate embedded resources above
#
class GoatKidsRepresenter
  include Halogen

  property :count, value: 5
end

puts 'GoatRepresenter.new(embed: { kids: true }).render:'
puts
pp GoatRepresenter.new(embed: { kids: true }).render
#
# Result:
#
# {
#   id: 1,
#   age: 9.2,
#   full_name: "Gideon Goat",
#   _embedded: {
#     kids: { count: 5 }
#   },
#   _links: {
#     self: { href: '/goats/1' },
#     root: { href: '/goats"'},
#     find: { href: '/goats/{?id}', templated: true }
#   }
# }
#

puts
puts 'GoatRepresenter.new.render:'
puts
pp GoatRepresenter.new.render
#
# Result:
#
# {
#   id: 1,
#   age: 9.2,
#   full_name: "Gideon Goat",
#   _links: {
#     self: { href: '/goats/1' },
#     root: { href: '/goats"'},
#     find: { href: '/goats/{?id}', templated: true }
#   }
# }
