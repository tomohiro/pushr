Pushr:  Push Notification for Gmail to iPhone
================================================================================


Required
--------------------------------------------------------------------------------

- [Boxcar](http://boxcar.io/) Account, and add Growl (API) service.
- Ruby 1.9.2
- [Bundler](http://gembundler.com/)
- See [Gemfile](https://github.com/Tomohiro/pushr/blob/master/Gemfile)


Screenshot
--------------------------------------------------------------------------------

![Boxcar Image](http://dl.dropbox.com/u/173097/pushr/boxcar_ss.png)

Getting Started
--------------------------------------------------------------------------------

### Installation

    git clone git://github.com/Tomohiro/pushr.git
    cd pushr
    bundle install --path vendor/bundle


### Run

    bundle exec ruby pushr.rb


### Easy daemonize

    nohup bundle exec ruby pushr.rb &


Thanks
--------------------------------------------------------------------------------

- [Gmail Icon](http://findicons.com/icon/450383/gmail) by [Wojciech Walczyszyn](http://wwalczyszyn.deviantart.com/)

License
--------------------------------------------------------------------------------

See [LICENSE](https://github.com/Tomohiro/pushr/blob/master/LICENSE)
