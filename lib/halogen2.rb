#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'json'

# HAL+JSON generator
#
# Provides a framework-agnostic interface for generating HAL+JSON
# representations of resources
#
module Halogen2
  # Provide Halogen methods for the including module
  #
  # @return [Module]
  #
  def self.included(base)
    base.extend ClassMethods

    base.send :include, Properties
    base.send :include, Links
    base.send :include, Embeds

    config.extensions.each { |extension| base.send :include, extension }

    base.send :attr_reader, :options
  end

  module ClassMethods # :nodoc:
    # @return [Halogen::Definitions] the definitions container instance
    #
    def definitions
      @definitions ||= Definitions.new
    end

    # @param [Symbol, String] name of the resource
    #
    # @return [Module] self
    #
    def resource(name)
      include Resource

      define_resource(name)
    end

    # @param [Symbol, String] name of the collection
    #
    # @return [Module] self
    #
    def collection(name)
      include Collection

      define_collection(name)
    end

    def collection?
      false
    end

    def render(resource, representer_options = {})
      result = {}
      prop_definitions = self.definitions.fetch("Halogen::Properties::Definition", [])
      prop_definitions.each do |prop_definition|
        result[prop_definition.name] = send("get_property_#{prop_definition.name.to_s}", resource)
      end

      representer_options[:representer] = self unless representer_options[:representer]

      get_embeds(resource, result, representer_options) if respond_to?(:get_embeds)

      result
    end
  end

  class << self
    # @yield [Halogen::Configuration] configuration instance for modification
    #
    def configure
      yield config
    end

    # Configuration instance
    #
    # @return [Halogen::Configuration]
    #
    def config
      @config ||= Configuration.new
    end
  end
end

require 'halogen2/collection'
require 'halogen2/configuration'
require 'halogen2/definition'
require 'halogen2/definitions'
require 'halogen2/embeds'
require 'halogen2/errors'
require 'halogen2/links'
require 'halogen2/properties'
require 'halogen2/resource'
require 'halogen2/hash_util'
require 'halogen2/version'

require 'halogen2/railtie' if defined?(::Rails)
