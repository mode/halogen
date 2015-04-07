# encoding: utf-8
#
module Halogen
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

      base.send :include, InstanceMethods

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
    end

    module InstanceMethods # :nodoc:
      # Override super to ensure that the primary collection is always embedded
      #
      # @param key [String] the embed key to check
      #
      # @return [true, false] whether the given key should be embedded
      #
      def embed?(key)
        super || key == self.class.collection_name
      end
    end
  end
end
