require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'bundler/setup'
Bundler.setup

require 'halogen'
