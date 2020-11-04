module Halogen2
  # Each representer class has a Halogen2::Definitions instance which stores
  # Halogen2::Definition instances by type.
  #
  class Definitions < Hash
    # @param definition [Halogen2::Definition]
    #
    # @return [Halogen2::Definition] the added definition
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
