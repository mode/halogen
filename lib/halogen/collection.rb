module Halogen2
  # Behavior for representers with a primary collection resource.
  #
  # The main reason to declare a collection is that the resource with that name
  # will always be embedded during rendering.
  #
  module Collection
    def self.included(base) # :nodoc:
      if base.included_modules.include?(Resource)
        fail InvalidCollection, "#{base.name} has already defined a resource"
      end

      base.extend ClassMethods

      base.class.send :attr_accessor, :collection_name
    end

    module ClassMethods # :nodoc:
      # @param name [Symbol, String] name of the collection
      #
      # @return [Module] self
      #
      def define_collection(name)
        self.collection_name = name.to_s
      end

      def collection?
        true
      end
    end
  end
end
