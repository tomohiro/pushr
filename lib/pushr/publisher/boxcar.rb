require 'rubygems'
require 'boxcar_api'

module Pushr
  module Publisher
    class Boxcar
      def initialize config
        @boxcar = BoxcarAPI::User.new config.boxcar_email, config.boxcar_password
      end

      def push info
        @boxcar.notify info[:subject], info[:from], nil, 'https://gmail.com', 'http://dl.dropbox.com/u/173097/pushr/gmail.png'
          $logger.info "Push to Boxcar #{info[:subject]}"
      end

      def destruct
        @boxcar = nil
      end
    end
  end
end
