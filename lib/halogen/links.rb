module Halogen2
  module Links # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods # :nodoc:
      # @return [Halogen2::Links::Definition]
      #
      def link(name, *args, &procedure)
        definitions.add(Definition.new(name, *args, procedure))
      end

      def get_links(_resource, result, representer_options)
        result[:_links] ||= {}
        self.definitions.fetch("Halogen2::Links::Definition", []).each do |definition|
          next unless definition.enabled?(representer_options[:representer], representer_options)
          value = definition.value(nil)

          result[:_links][definition.name] = value if value
        end
        result.delete(:'_links') unless result[:'_links'].any?
      end

    end
  end
end

require 'halogen2/links/definition'
