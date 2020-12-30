module Halogen
  module Embeds # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods # :nodoc:
      # @param name [Symbol, String]
      # @param options [nil, Hash]
      #
      # @return [Halogen::Embeds::Definition]
      #
      def embed(name, options = {}, &procedure)
        if options[:representer]
          define_singleton_method("get_embedded_#{name}") do |resource, definition, result = {}, representer_options|
            result.tap do
              result[:'_embedded'] ||= {}
              value = collection? ? resource : resource.send(name)

              representer_options[:representer] = definition.options[:representer]

              child = get_embedded_child(value, name, representer_options)

              result[:'_embedded'][name] = child if child
            end

            result.delete(:'_embedded') unless result[:'_embedded'].any?
          end
        end

        definitions.add(Definition.new(name, options, procedure))
      end

      def get_embeds(resource, result, representer_options)
        self.definitions.fetch("Halogen::Embeds::Definition", []).each do |definition|
          next unless definition.enabled?(representer_options[:representer], representer_options, collection_name)
          send(:"get_embedded_#{definition.name}", resource, definition, result, representer_options)
        end
      end

      def get_embedded_child(value, key, representer_options)
        return unless value

        repr = representer_options[:representer]
        # puts "key #{key}"
        child_options = child_embed_opts(key, representer_options)
        # puts "child options #{child_options.inspect}"
        if value.is_a?(Array)
          value.map { |item| render_child(item, repr, child_options) }.compact
        else
          render_child(value, repr, child_options)
        end
      end

      # @param key [String]
      #
      # @return [Hash]
      #
      def child_embed_opts(key, representer_options)
        opts = embed_options(representer_options).fetch(key.to_s, {})

        # Turn { :report => 1 } into { :report => {} } for child
        opts = {} unless opts.is_a?(Hash)

        opts
      end

      # @param repr [Object] the child representer
      # @param opts [Hash] the embed options to assign to the child
      #
      # @return [nil, Hash] the rendered child
      #
      def render_child(value, repr, child_options = {})
        return unless repr.included_modules.include?(Halogen)

        child_options[:embed] ||= {}
        child_options[:embed].merge!(child_options)
        child_options[:parent] = self

        repr.render(value, child_options)
      end

      # @return [Hash] hash of options with top level string keys
      #
      def embed_options(representer_options)
        @_embed_options ||= representer_options.fetch(:embed, {}).tap do |result|
          Halogen::HashUtil.stringify_keys!(result)
        end
      end
    end
  end
end

require 'halogen/embeds/definition'
