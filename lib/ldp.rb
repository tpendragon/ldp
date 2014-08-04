require 'ldp/version'
require 'linkeddata'
require 'logger'
require 'http_logger'

module Ldp
  RDF::Graph.send(:include, RDF::Isomorphic)

  require 'ldp/client'
  require 'ldp/uri'

  extend Uri

  autoload :Response, 'ldp/response'
  autoload :Resource, 'ldp/resource'
  autoload :Container, 'ldp/container'

  autoload :Orm, 'ldp/orm'

  class HttpError < RuntimeError; end
  class NotFound < HttpError; end
  class EtagMismatch < HttpError; end

  class << self
    def logger
      @logger ||= Logger.new(STDOUT).tap do |log|
        log.level = Logger::WARN
      end
    end
    
    def instrument *args, &block
      if defined?(::ActiveSupport) && defined?(::ActiveSupport::Notifications)
        ActiveSupport::Notifications.instrument *args, &block
      else
        yield
      end
    end

    attr_writer :logger
  end
  
end
