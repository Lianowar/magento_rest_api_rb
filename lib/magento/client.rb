## Main module

require 'rest-client'
require 'json'
require 'hashugar'
require 'magento/client/customers'

module Magento

  ## REST Client
  class Client

    include Magento::Client::Customers

    attr_reader :customer_token, :default_headers, :resource

    def initialize(customer_token = nil, default_headers = nil)
      @customer_token = customer_token
      @default_headers = default_headers.nil? ? { accept: :json, content_type: :json } : default_headers
      @default_headers += { authorization: "Bearer #{@customer_token}" } unless @customer_token.nil?
      @resource = 'http://shop.neurburgring.tk/rest'
    end

    def login_user(user_name, password)
      response = RestClient.post(resource + '/V1/integration/customer/token',
                                        { "username" => user_name, "password" => password }.to_json,
                                        default_headers).body
      @customer_token = JSON.parse(response)
      default_headers[:authorization] = "Bearer #{@customer_token}"
      customer_token
    end

  end

end