module Halogen2
  # Provide Rails-specific extensions if loaded in a Rails application
  #
  class Railtie < ::Rails::Railtie
    initializer 'halogen2' do |_app|
      Halogen2.config.extensions << ::Rails.application.routes.url_helpers
    end
  end
end
