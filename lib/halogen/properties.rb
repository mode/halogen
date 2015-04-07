# encoding: utf-8
#
module Halogen
  module Properties # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods

      base.send :include, InstanceMethods
    end

    module ClassMethods # :nodoc:
      # @param name [Symbol, String]
      # @param options [nil, Hash]
      #
      # @return [Halogen::Embeds::Definition]
      #
      def property(name, options = {}, &procedure)
        definitions.add(Definition.new(name, options, procedure))
      end
    end

    module InstanceMethods # :nodoc:
      # @return [Hash] the rendered hash with properties, if any
      #
      def render
        super.merge(properties)
      end

      # @return [Hash] properties from definitions
      #
      def properties
        render_definitions(Definition.name) do |definition, result|
          result[definition.name] = definition.value(self)
        end
      end
    end
  end
end

require 'halogen/properties/definition'
