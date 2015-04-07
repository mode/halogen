# encoding: utf-8
#
module Halogen
  module Links
    class Definition < Halogen::Definition # :nodoc
      # Links have special keywords that other definitions don't, so override
      # the standard initializer to build options from keywords
      #
      def initialize(name, *args, procedure)
        super name, self.class.build_options(args), procedure
      end

      # @return [true] if nothing is raised
      #
      # @raise [Halogen::InvalidDefinition] if the definition is invalid
      #
      def validate
        super

        return true if procedure || options.key?(:value)

        fail InvalidDefinition,
             'Link requires either procedure or explicit value'
      end

      # @return [nil, Hash]
      #
      def value(_instance)
        hrefs = super

        attrs = options.fetch(:attrs, {})

        case hrefs
        when Array
          hrefs.map { |href| attrs.merge(href: href) }
        when nil
          # no-op
        else
          attrs.merge(href: hrefs)
        end
      end

      class << self
        # Build hash of options from flexible definition arguments
        #
        # @param args [Array] the raw definition arguments
        #
        # @return [Hash] standardized hash of options
        #
        def build_options(args)
          {}.tap do |options|
            options.merge!(args.pop) if args.last.is_a?(Hash)

            options[:attrs] ||= {}
            options[:attrs].merge!(build_attrs(args))
          end
        end

        # @param keywords [Array] array of special keywords
        #
        # @raise [Halogen::InvalidDefinition] if a keyword is unrecognized
        #
        def build_attrs(keywords)
          keywords.each_with_object({}) do |keyword, attrs|
            case keyword
            when :templated, 'templated'
              attrs[:templated] = true
            else
              fail InvalidDefinition, "Unrecognized link keyword: #{keyword}"
            end
          end
        end
      end
    end
  end
end
