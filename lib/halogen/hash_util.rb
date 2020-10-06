module Halogen
  module HashUtil # :nodoc:
    extend self

    # Transform hash keys into strings if necessary
    #
    # @param hash [Hash]
    #
    # @return [Hash]
    #
    def stringify_keys!(hash)
      hash.transform_keys!(&:to_s)
    end

    # Transform hash keys into symbols if necessary
    #
    # @param hash [Hash]
    #
    # @return [Hash]
    #
    def symbolize_keys!(hash)
      hash.transform_keys!(&:to_sym)
    end
  end
end
