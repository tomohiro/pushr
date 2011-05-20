#!/usr/bin/env ruby

require 'kconv'
require 'time'
require 'logger'
require 'net/imap'

require 'rubygems'
require 'pit'
require 'boxcar_api'

ENV['EDITOR'] = 'vi' if ENV['EDITOR'].nil?

config = Pit.get('push.gmail.com', :require => {
  :email           => 'yourname@gmail.com',
  :password        => 'your password in gmail',
  :boxcar_email    => 'yourname@example.com',
  :boxcar_password => 'your password in boxcar'
})

logger = Logger.new STDOUT
logger.level = Logger::INFO

begin
  gmail = Net::IMAP.new 'imap.gmail.com', 993, true, nil, false
    logger.info 'Connect Gmail'

  gmail.login config[:email], config[:password]
    logger.info "Login #{config[:email]}"

  boxcar = BoxcarAPI::User.new config[:boxcar_email], config[:boxcar_password]
    logger.info "Connect Boxcar #{config[:boxcar_email]}"

  head = nil

  loop do
    gmail.select 'INBOX'
      logger.debug 'Select inbox'

    unseen = gmail.search ['UNSEEN']

    if unseen.nil? or unseen == 0
      logger.info "No mail for #{config[:email]}"
      sleep 30
      next
    end

    mail = gmail.fetch(unseen.last, 'ENVELOPE').first.attr['ENVELOPE']
      logger.debug 'Checked'

    from = mail.from.first.name.toutf8
    subject = mail.subject.toutf8
    date = Time.parse mail.date
      logger.debug "#{head} < #{date} #{subject}"

    if head.nil? or head < date
      head = date
      res = boxcar.notify subject, from, nil, 'https://gmail.com', 'http://dl.dropbox.com/u/173097/gmail.png'
        logger.info res
    end

    sleep 30
  end
rescue Exception => e
  logger.error "#{__FILE__}: #{__LINE__}L"
  logger.error e.inspect
ensure
  gmail.logout
    logger.info 'Logout Gmail'

  gmail.disconnect
    logger.info 'Disconnect Gmail'
end
