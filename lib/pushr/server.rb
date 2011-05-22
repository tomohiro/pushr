require 'logger'

require 'publisher/gmail'
require 'subscriber/boxcar'

module Pushr
  class Server
    def initialize
      $logger = Logger.new STDOUT
      $logger.level = Logger::INFO
    end

    def self.run
      self.new.run
    end

    def run
      begin
        @publisher  = Pushr::Publisher::Gmail.new $config
        @subscriber = Pushr::Subscriber::Boxcar.new $config

        loop do
          @publisher.start { |info| @subscriber.notify info }
          sleep 30
        end

      rescue Exception => e
        $logger.error e.inspect
      ensure
        @crawler.destruct
        @publisher.destruct
      end
    end
  end
end
