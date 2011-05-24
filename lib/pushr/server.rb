require 'publisher/gmail'
require 'publisher/exception'
require 'subscriber/boxcar'

module Pushr
  class Server
    def initialize
      @logger = Pushr.logger Module.nesting.first
    end

    def self.run
      self.new.run
    end

    def run
      @logger.info 'Run'

      begin
        @publisher  = Pushr::Publisher::Gmail.new $config
        @subscriber = Pushr::Subscriber::Boxcar.new $config

        loop do
          @publisher.start { |info| @subscriber.notify info }
          sleep 30
        end

      rescue Exception => e
        @logger.error e.inspect
        @subscriber.notify Pushr::Publisher::Exception.new e
      ensure
        @publisher.destruct
        @subscriber.destruct
      end
    end
  end
end
