Pushr:  Push Notification for Gmail to iPhone
================================================================================


Required
--------------------------------------------------------------------------------

- [Boxcar](http://boxcar.io/) Account, and add Growl (API) service.
- Ruby 1.9.2
- [Bundler](http://gembundler.com/)
- See Gemfile


Screenshot
--------------------------------------------------------------------------------

![Boxcar Image](http://dl.dropbox.com/u/173097/boxcar.png)

Getting Started
--------------------------------------------------------------------------------

### Installation

    $ git clone git://github.com/Tomohiro/pushr.git
    $ cd pushr
    $ bundle install --path vendor/bundle


### Run

    $ bundle exec ruby pushr.rb


### Easy daemonize

    $ nohup bundle exec ruby pushr.rb &


License
--------------------------------------------------------------------------------

See LICENSE
