require 'active_support'

class Configuration
  attr_accessor :resource_host, :admin_login, :admin_password,
                :default_website_id, :default_user_group_id,
                :default_store_id, :default_store_code

  def initialize
    @resource_host = nil
    @admin_login = nil
    @admin_password = nil
    @default_website_id = nil
    @default_user_group_id = nil
    @default_store_id = nil
    @default_store_code = nil
  end
end