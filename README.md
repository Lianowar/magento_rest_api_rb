# MagentoRestApiRb

This is Ruby wrapper for Magento Shop REST API. It is currently under development and some features not implemented or not user friendly, if you want to fix something - please make pull request.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magento_rest_api_rb', github: 'Lianowar/magento_rest_api_rb'
```

And then execute:

    $ bundle

## Usage
Config initializers/magento_rest_api_rb.rb
```ruby
require 'magento_rest_api_rb'

MagentoRestApiRb.resource_host = '<YOUR_HOST>' # e.g 'http://exmaple.com/rest'
MagentoRestApiRb.admin_login = '<YOUR_ADMIN_USERNAME>'
MagentoRestApiRb.admin_password = '<YOUR_ADMIN_PASSWORD>'
MagentoRestApiRb.default_website_id = '<DEFAULT_STORE_ID>'
MagentoRestApiRb.default_user_group_id = '<DEFAULT_USER_GROUP_ID>'
MagentoRestApiRb.default_store_id = '<DEFAULT_STORE_ID>'
MagentoRestApiRb.default_store_code = '<DEFAULT_STORE_CODE>' # for localization mostly
```

Use
```ruby
# All params are optional, customer token getting from client.login_customer(email, plain password)
# guest_cart_key 
client = Magento::Client.new('<customer_token>', '<default_headers>', '<guest_cart_key>', '<store_code>')
response, status = client.get_cart # status: true, false (false if server return error)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Lianowar/magento_rest_api_rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MagentoRestApiRb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/magento_rest_api_rb/blob/master/CODE_OF_CONDUCT.md).
