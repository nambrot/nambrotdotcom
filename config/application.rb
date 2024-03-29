require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require 'actionpack/action_caching'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Nambrotdotcom
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile += ['multi_part_tweets.js', 'multi_part_tweets.css', 'basic.css', 'basic.js', 'madagascar.css', 'madagascar.js', 'custom.modernizr.js', 'aroundtheworld.js', 'aroundtheworld.css', 'about.css', 'applicaiton.js', 'application.css']
    config.autoload_paths += [
      "#{config.root}/lib/nams_paas"
    ]

    config.autoload_paths << Rails.root.join('lib')

    config.action_controller.default_url_options = { :trailing_slash => true }
    config.logger = Logger.new('/dev/null')
    Ahoy.mount = false
    config.lograge.enabled = false
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.custom_options = lambda do |event|
      # capture some specific timing values you are interested in
      {
        host: event.payload[:host],
        remote_ip: event.payload[:remote_ip],
        request_id: event.payload[:request_id],
        params: event.payload[:params],
        format: event.payload[:format],
        stream: "#{Rails.env}-request"
      }
    end
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      user_name:            'nambrot@googlemail.com',
      password:             ENV["GMAIL_PASSWORD"],
      authentication:       'plain',
      enable_starttls_auto: true  }
  end
end
