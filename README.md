[![Gem Version](https://badge.fury.io/rb/omniauth-dingding.svg)](https://badge.fury.io/rb/omniauth-dingding)
[![Build Status](https://github.com/jinhucheung/omniauth-dingding/actions/workflows/main.yml/badge.svg)](https://github.com/jinhucheung/omniauth-dingding/actions)

# Omniauth Dingding

This is the official OmniAuth strategy for authenticating to DingTalk. To use it, you'll need to sign up for an OAuth2 Application ID and Secret on the [DingTalk Applications Page](https://open-dev.dingtalk.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-dingding'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install omniauth-dingding
```

## Usage

`OmniAuth::Strategies::Dingding` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dingding, ENV['DINGDING_APP_ID'], ENV['DINGDING_APP_SECRET']
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jinhucheung/omniauth-dingding.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
