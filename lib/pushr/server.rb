require 'logger'

require 'pushr/crawler/gmail'
require 'pushr/publisher/boxcar'

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
        @crawler   = Pushr::Crawler::Gmail.new $config
        @publisher = Pushr::Publisher::Boxcar.new $config

        loop do
          @crawler.start  { |info| @publisher.push info }
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
