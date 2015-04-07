# encoding: utf-8
#
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
    end
  end
end
