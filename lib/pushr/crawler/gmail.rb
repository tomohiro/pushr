require 'kconv'
require 'time'
require 'net/imap'

module Pushr
  module Crawler
    class Gmail
      def initialize config
        @gmail = Net::IMAP.new 'imap.gmail.com', 993, true, nil, false
          $logger.info 'Connect to Gmail'

        @gmail.login config.email, config.password
          $logger.info 'Login to Gmail'

        @head = nil
      end

      def start
        @gmail.select 'INBOX'
          $logger.info 'Select inbox'

        unseen = @gmail.search ['UNSEEN']

        return if unseen.empty?

        mail = @gmail.fetch(unseen.last, 'ENVELOPE').first.attr['ENVELOPE']
        date = Time.parse mail.date

        if @head.nil? or @head < date
          @head = date

          info = {
            :subject => mail.subject.toutf8,
            :from    => (mail.from.first.name || "#{mail.from.first.mailbox}@#{mail.from.first.host}").toutf8
          }

          yield info
        end
      end

      def destruct
        @gmail.logout
          $logger.info 'Logout from Gmail'

        @gmail.disconnect
          $logger.info 'Disconnect from Gmail'

        @gmail = nil
      end
    end
  end
end
