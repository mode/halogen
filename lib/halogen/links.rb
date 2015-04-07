# encoding: utf-8
#
module Halogen
  module Links # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods

      base.send :include, InstanceMethods
    end

    module ClassMethods # :nodoc:
      # @return [Halogen::Embeds::Definition]
      #
      def link(name, *args, &procedure)
        definitions.add(Definition.new(name, *args, procedure))
      end
    end

    module InstanceMethods # :nodoc:
      # @return [Hash] the rendered hash with links, if any
      #
      def render
        decorate_render :links, super
      end

      # @return [Hash] links from definitions
      #
      def links
        render_definitions(Definition.name) do |definition, result|
          attrs = definition.options.fetch(:attrs, {})

          href = definition.value(self)

          result[definition.name] = attrs.merge(href: href) if href
        end
      end
    end
  end
end

require 'halogen/links/definition'
