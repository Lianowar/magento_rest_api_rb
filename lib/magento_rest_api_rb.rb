require 'magento_rest_api_rb/version'
require 'magento_rest_api_rb/configuration'
require 'magento/client'

module MagentoRestApiRb
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
