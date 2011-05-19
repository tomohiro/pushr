#!/usr/bin/env ruby

require 'net/imap'
require 'kconv'
require 'time'
require 'logger'

require 'rubygems'
require 'pit'

ENV['EDITOR'] = 'vi' if ENV['EDITOR'].nil?

config = Pit.get('push.gmail.com', :require => {
  :email    => 'yourname@gmail.com',
  :password => 'your password in gmail',
  :username => 'your username in im.kayac.com'
})

logger = Logger.new STDOUT
logger.level = Logger::DEBUG

begin
  gmail = Net::IMAP.new 'imap.gmail.com', 993, true, nil, false
    logger.info 'Connect Gmail'

  gmail.login config[:email], config[:password]
    logger.info "Login #{config[:email]}"

  head = nil

  loop do
    gmail.select 'INBOX'
      logger.debug 'Select inbox'

    mail = gmail.fetch(gmail.search(['UNSEEN']).last, 'ENVELOPE').first.attr['ENVELOPE']
      logger.debug 'Checked'

    subject = mail.subject.toutf8
    date = Time.parse mail.date
      logger.debug "#{head} < #{date} #{subject}"

    if head.nil? or head < date
      head = date
      `curl -d 'message=[Gmail] #{subject}' http://im.kayac.com/api/post/#{config[:username]}`
        logger.info "Push to #{config[:username]}"
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
