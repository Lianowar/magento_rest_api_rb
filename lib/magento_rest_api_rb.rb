require "magento_rest_api_rb/version"
require 'magento/client'

module MagentoRestApiRb

  mattr_accessor :resource_host
  mattr_accessor :admin_login
  mattr_accessor :admin_password
  mattr_accessor :default_website_id
  mattr_accessor :default_user_group_id
  mattr_accessor :default_store_id
end
