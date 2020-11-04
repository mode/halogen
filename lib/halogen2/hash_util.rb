module Halogen2
  module HashUtil # :nodoc:
    extend self

    # Transform hash keys into strings if necessary
    #
    # @param hash [Hash]
    #
    # @return [Hash]
    #
    def stringify_keys!(hash)
      transform_keys!(hash, &:to_s)
    end

    # Transform hash keys into symbols if necessary
    #
    # @param hash [Hash]
    #
    # @return [Hash]
    #
    def symbolize_keys!(hash)
      transform_keys!(hash, &:to_sym)
    end

    # Transform hash keys according to block
    #
    # @param hash [Hash]
    #
    # @return [Hash]
    #
    def transform_keys!(hash)
      hash.keys.each { |key| hash[yield(key)] = hash.delete(key) }

      hash
    end
  end
end
