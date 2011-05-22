require 'ostruct'
require 'rubygems'
require 'pit'

require 'pushr/server'

ENV['EDITOR'] = 'vi' if ENV['EDITOR'].nil?

$config = OpenStruct.new(
  Pit.get('pushr', :require => {
      :email           => 'yourname@gmail.com',
      :password        => 'your password in gmail',
      :boxcar_email    => 'yourname@example.com',
      :boxcar_password => 'your password in boxcar'
    }
  )
)

module Pushr
end
