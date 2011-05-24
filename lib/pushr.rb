require 'logger'
require 'ostruct'
require 'rubygems'
require 'pit'

require 'server'

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
  def self.logger module_name
    logger = Logger.new STDOUT
    logger.level = Logger::INFO
    logger.progname = module_name || Module.nesting.first
    logger
  end
end
