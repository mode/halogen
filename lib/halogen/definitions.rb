# encoding: utf-8
#
module Halogen
  # Each representer class has a Halogen::Definitions instance which stores
  # Halogen::Definition instances by type.
  #
  class Definitions < Hash
    # @param definition [Halogen::Definition]
    #
    # @return [Halogen::Definition] the added definition
    #
    def add(definition)
      type = definition.class.name

      definition.validate

      self[type] ||= []
      self[type] << definition

      definition
    end
  end
end
