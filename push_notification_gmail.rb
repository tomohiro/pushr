#!/usr/bin/env ruby
 
require 'net/https'
require 'time'
require 'rubygems'
require 'nokogiri'
require 'pit'

ENV['EDITOR'] = 'vi' if ENV['EDITOR'].nil?

config = Pit.get('push.gmail.com', :require => {
  :email    => 'your email in gmail',
  :password => 'your password in gmail',
  :username => 'your username in im.kayac.com'
})


proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  https = Net::HTTP::Proxy(URI.parse(proxy).host, URI.parse(proxy).port).new('mail.google.com', 443)
else
  https = Net::HTTP.new('mail.google.com', 443)
end
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_NONE

head = Time.now.utc

loop do
  request = Net::HTTP::Get.new('/mail/feed/atom')
  request.basic_auth(config[:email], config[:password])
  responce = https.request(request).body

  xml = Nokogiri::XML(responce)
  mail = (xml/'entry').first

  if mail
    title = "[Gmail] #{(mail/'title').text}"
    get   = Time.parse (mail/'modified').text

    if head < get
      head = get
      `curl -d 'message=#{title}' http://im.kayac.com/api/post/#{config[:username]}`
    end
  end

  sleep 30
end
