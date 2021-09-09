require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module RadioArchives
  class Application < Rails::Application
    config.load_defaults 6.1

    config.time_zone = 'Osaka'
    config.beginning_of_week = :monday
    config.i18n.default_locale = :ja

    console do
      require 'pry'
      config.console = Pry
    end

    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework false
    end
  end
end
