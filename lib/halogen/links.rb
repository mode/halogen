module Halogen
  module Links # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods

      base.send :include, InstanceMethods
    end

    module ClassMethods # :nodoc:
      # @return [Halogen::Links::Definition]
      #
      def link(name, *args, &procedure)
        definitions.add(Definition.new(name, *args, procedure))
      end
    end

    module InstanceMethods # :nodoc:
      # @return [Hash] the rendered hash with links, if any
      #
      def render
        if options.fetch(:include_links, true)
          decorate_render :links, super
        else
          super
        end
      end

      # @return [Hash] links from definitions
      #
      def links
        render_definitions(Definition.name) do |definition, result|
          value = definition.value(self)

          result[definition.name] = value if value
        end
      end
    end
  end
end

require 'halogen/links/definition'
