require 'active_support/concern'
require 'rails/rack/logger'

module Rails
  module Rack
    # Overwrites defaults of Rails::Rack::Logger that cause
    # unnecessary logging.
    # This effectively removes the log lines from the log
    # that say:
    # Started GET / for 192.168.2.1...
    class Logger
      # Overwrites Rails 3.2 code that logs new requests
      def call_app(*args)
        env = args.last
        @app.call(env)
      ensure
        ActiveSupport::LogSubscriber.flush_all!
      end

      # Overwrites Rails 3.0/3.1 code that logs new requests
      def before_dispatch(_env)
      end
    end
  end
end

module NamsPaas
  class RequestLogSubscriber < ActiveSupport::LogSubscriber
    def logger
      @logger ||= ::Logger.new(STDOUT)
      @logger.formatter = Formatter.new
      @logger
    end

    def process_action event
      return if event.payload[:controller].in?([Ahoy::EventsController, Ahoy::VisitsController].map(&:to_s))
      logger.info event.payload.merge(environment: Rails.env, stream: 'request',view_runtime: event.payload[:view_runtime],
      db_runtime: event.payload[:db_runtime],
      duration: event.duration)
    end

    class Formatter
      def call severity, time, progname, msg
        msg.merge(timestamp: Time.now.to_i, severity: severity).to_json + "\n"
      end
    end
  end

  class EventLogSubscriber < ActiveSupport::LogSubscriber
    def logger
      @logger ||= ::Logger.new(STDOUT)
      @logger.formatter = Formatter.new
      @logger
    end

    def event_log event
      logger.info event.payload.merge(environment: Rails.env, stream: 'event')
    end

    class Formatter
      def call severity, time, progname, msg
        msg.merge(timestamp: Time.now.to_i, severity: severity).to_json + "\n"
      end
    end
  end

  class ErrorLogSubscriber < ActiveSupport::LogSubscriber
    def logger
      @logger ||= ::Logger.new(STDOUT)
      @logger.formatter = Formatter.new
      @logger
    end

    def error_log event
      logger.error event.payload.merge(environment: Rails.env, stream: 'error')
    end

    class Formatter
      def call severity, time, progname, msg
        msg.merge(timestamp: Time.now.to_i, severity: severity).to_json + "\n"
      end
    end
  end

  class AhoyLogSubscriber < ActiveSupport::LogSubscriber
    def logger
      @logger ||= ::Logger.new(STDOUT)
      @logger.formatter = Formatter.new
      @logger
    end

    def ahoy_log event
      logger.info event.payload.merge(environment: Rails.env, stream: 'context')
    end

    class Formatter
      def call severity, time, progname, msg
        msg.merge(severity: severity).to_json + "\n"
      end
    end
  end

  def self.instrument(event_type, payload)
    ActiveSupport::Notifications.instrument("event_log.nams_paas", payload.merge(event_type: event_type))
  end

  def self.track_error(payload)
    ActiveSupport::Notifications.instrument("error_log.nams_paas", payload.merge(event_type: 'RAILS_ERROR'))
  end

  def self.track_ahoy_event(payload)
    ActiveSupport::Notifications.instrument("ahoy_log.nams_paas", payload)
  end
end



 def unsubscribe(component, subscriber)
    events = subscriber.public_methods(false).reject { |method| method.to_s == 'call' }
    events.each do |event|
      ActiveSupport::Notifications.notifier.listeners_for("#{event}.#{component}").each do |listener|
        if listener.instance_variable_get('@delegate') == subscriber
          ActiveSupport::Notifications.unsubscribe listener
        end
      end
    end
  end
ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
  case subscriber
  when ActionView::LogSubscriber
    unsubscribe(:action_view, subscriber)
  when ActionController::LogSubscriber
    unsubscribe(:action_controller, subscriber)
  end
end

NamsPaas::RequestLogSubscriber.attach_to :action_controller
NamsPaas::EventLogSubscriber.attach_to :nams_paas
NamsPaas::AhoyLogSubscriber.attach_to :nams_paas
NamsPaas::ErrorLogSubscriber.attach_to :nams_paas
