module Halogen2
  # Behavior for representers with a single primary resource
  #
  module Resource
    def self.included(base) # :nodoc:
      if base.included_modules.include?(Collection)
        fail InvalidResource, "#{base.name} has already defined a collection"
      end

      base.extend ClassMethods

      base.send :include, InstanceMethods

      base.send :attr_reader, :resource

      base.class.send :attr_accessor, :resource_name
    end

    module ClassMethods # :nodoc:
      # @param name [Symbol, String] name of the resource
      #
      # @return [Module] self
      #
      def define_resource(name)
        self.resource_name = name.to_s

        alias_method name, :resource
      end

      # Override standard property definition for resource-based representers
      #
      # @param name [Symbol, String] name of the property
      # @param options [nil, Hash] property options for definition
      #
      def property(name, options = {}, &procedure)
        super.tap do |definition|
          unless definition.procedure || definition.options.key?(:value)
            definition.procedure = proc { resource.send(name) }
          end
        end
      end
    end

    module InstanceMethods # :nodoc:
      # Override standard initializer to assign primary resource
      #
      # @param resource [Object] the primary resource
      #
      def initialize(resource, *args)
        @resource = resource

        super *args
      end
    end
  end
end
