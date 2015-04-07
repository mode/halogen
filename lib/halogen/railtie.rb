# encoding: utf-8
#
module Halogen
  # Provide Rails-specific extensions if loaded in a Rails application
  #
  class Railtie < ::Rails::Railtie
    initializer 'halogen' do |_app|
      Halogen.config.extensions << ::Rails.application.routes.url_helpers
    end
  end
end
