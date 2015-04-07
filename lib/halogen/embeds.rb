# encoding: utf-8
#
module Halogen
  module Embeds # :nodoc:
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
      def embed(name, options = {}, &procedure)
        definitions.add(Definition.new(name, options, procedure))
      end
    end

    module InstanceMethods # :nodoc:
      # @return [Hash] the rendered hash with embedded resources, if any
      #
      def render
        decorate_render :embedded, super
      end

      # @return [Hash] hash of rendered resources to embed
      #
      def embedded
        render_definitions(Definition.name) do |definition, result|
          next unless embed?(definition.name.to_s)

          value = instance_eval(&definition.procedure)

          child = embedded_child(definition.name.to_s, value)

          result[definition.name] = child if child
        end
      end

      # @return [nil, Hash, Array<Hash>] either a single rendered child
      #   representer or an array of them
      #
      def embedded_child(key, value)
        return unless value

        opts = child_embed_opts(key)

        if value.is_a?(Array)
          value.map { |item| render_child(item, opts) }.compact
        else
          render_child(value, opts)
        end
      end

      # @param key [String]
      #
      # @return [Hash]
      #
      def child_embed_opts(key)
        opts = embed_options.fetch(key, {})

        # Turn { :report => 1 } into { :report => {} } for child
        opts = {} unless opts.is_a?(Hash)

        opts
      end

      # @param repr [Object] the child representer
      # @param opts [Hash] the embed options to assign to the child
      #
      # @return [nil, Hash] the rendered child
      #
      def render_child(repr, opts)
        return unless repr.class.included_modules.include?(Halogen)

        repr.options[:embed] ||= {}
        repr.options[:embed].merge!(opts)

        repr.options[:parent] = self

        repr.render
      end

      # @return [Hash] hash of options with top level string keys
      #
      def embed_options
        options.fetch(:embed, {}).tap do |result|
          Halogen::HashUtil.stringify_keys!(result)
        end
      end

      # @param key [String]
      #
      # @return [true, false] whether to embed the key
      #
      def embed?(key)
        return false unless embed_options.include?(key)

        !%w(0 false).include?(embed_options.fetch(key).to_s)
      end
    end
  end
end

require 'halogen/embeds/definition'
