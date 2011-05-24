require 'rubygems'
require 'boxcar_api'

module Pushr
  module Subscriber
    class Boxcar
      def initialize config
        @logger = Pushr.logger Module.nesting.first
        @boxcar = BoxcarAPI::User.new config.boxcar_email, config.boxcar_password
      end

      def notify info
        @boxcar.notify info.title, info.source, nil, info.link, info.icon
          @logger.info "Push #{info.title}"
      end

      def destruct
        @boxcar = nil
          @logger.info 'Release'
      end
    end
  end
end
