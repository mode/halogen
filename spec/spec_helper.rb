# encoding: utf-8
#
require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'bundler/setup'
Bundler.setup

require 'halogen'
