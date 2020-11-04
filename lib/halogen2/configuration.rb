module Halogen2
  # Simple configuration class
  #
  class Configuration
    # Array of extension modules to be included in all representers
    #
    # @return [Array<Module>]
    #
    def extensions
      @extensions ||= []
    end
  end
end
