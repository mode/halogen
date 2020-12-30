module Halogen
  module Embeds
    class Definition < Halogen::Definition # :nodoc:
      # @return [true] if nothing is raised
      #
      # @raise [Halogen::InvalidDefinition] if the definition is invalid
      #
      def validate
        super

        return true if procedure

        fail InvalidDefinition, "Embed #{name} must be defined with a proc"
      end

      # Check whether this definition should be embedded for the given class
      #
      # @param class [Object]
      #
      # @return [true, false]
      #
      def enabled?(representer_class, representer_options, resource)
        return false unless super(representer_class, representer_options, resource)

        if representer_class.respond_to?(:embed?)
          representer_class.embed?(name.to_s)
        else
          embed_via_options?(representer_class, representer_options)
        end
      end

      private

      # @param class [Object]
      #
      # @return [true, false]
      #
      def embed_via_options?(representer_class, representer_options)
        opts = representer_class.embed_options(representer_options)

        # Definition name must appear in instance embed option keys
        return false unless opts.include?(name.to_s)

        # Check value of embed option for definition name
        !%w(0 false).include?(opts.fetch(name.to_s).to_s)
      end
    end
  end
end
