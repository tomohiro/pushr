require 'kconv'
require 'time'
require 'net/imap'

module Pushr
  module Publisher
    class Gmail
      attr_reader :title, :source, :link, :icon

      def initialize config
        @logger = Pushr.logger Module.nesting.first

        @gmail = Net::IMAP.new 'imap.gmail.com', 993, true, nil, false
          @logger.info 'Connect'

        @gmail.login config.email, config.password
          @logger.info 'Login'

        @head   = nil
        @title  = nil
        @source = nil
        @link   = 'https://gmail.com'
        @icon   = 'http://dl.dropbox.com/u/173097/pushr/gmail.png'
      end

      def start
        @gmail.select 'INBOX'
          @logger.debug 'Select inbox'

        unseen = @gmail.search ['UNSEEN']

        return if unseen.empty?

        mail = @gmail.fetch(unseen.last, 'ENVELOPE').first.attr['ENVELOPE']
        date = Time.parse mail.date

        if @head.nil? or @head < date
          @head   = date
          @title  = mail.subject.toutf8
          @source = (mail.from.first.name || "#{mail.from.first.mailbox}@#{mail.from.first.host}").toutf8

          yield self
        end
      end

      def destruct
        @gmail.logout
          @logger.info 'Logout'

        @gmail.disconnect
          @logger.info 'Disconnect'

        @gmail = nil
      end
    end
  end
end
