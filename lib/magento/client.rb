## Main module

require 'rest-client'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'magento/client/customers'
require 'magento/client/products'
require 'magento/client/cart'
require 'magento/client/guest_cart'
require 'magento/client/wish_list'
require 'magento/client/checkout'
require 'magento/client/guest_checkout'
require 'magento/client/coupon'
require 'magento/client/order'

module Magento

  ## REST Client
  class Client

    include Magento::Client::Customers
    include Magento::Client::Products
    include Magento::Client::Cart
    include Magento::Client::GuestCart
    include Magento::Client::WishList
    include Magento::Client::Checkout
    include Magento::Client::GuestCheckout
    include Magento::Client::Coupon
    include Magento::Client::Order

    attr_reader :resource, :admin_token, :store_code
    attr_accessor :guest_cart_key, :customer_token, :default_headers

    def initialize(customer_token = nil, default_headers = nil, guest_cart_key = nil,
                   store_code = MagentoRestApiRb.default_store_code)
      @customer_token = customer_token
      @default_headers = default_headers.blank? ? { accept: :json, content_type: :json } : default_headers
      @default_headers[:authorization] = "Bearer #{@customer_token}" unless @customer_token.nil?
      @guest_cart_key = guest_cart_key
      @store_code = store_code

      raise Magento::Error, 'Has not resource host!' unless MagentoRestApiRb.resource_host.present?

      @resource = MagentoRestApiRb.resource_host.gsub(/\/$/, '')
      @resource += "/#{@store_code}" if @store_code.present?
    end

    # Login customer and get token from magento backend by customer email and password
    def login_customer(email, password)
      token_result, success = post_wrapper('/V1/integration/customer/token',
                              { "username" => email, "password" => password }.to_json,
                              default_headers)
      @customer_token = token_result if success
      default_headers[:authorization] = "Bearer #{customer_token}" if success
      return token_result, success
    end

    # Create new customer in magento backend
    def create_customer(customer_info, password)
      post_wrapper('/V1/customers',
                   { customer: customer_info,
                     password: password }.to_json,
                   admin_headers)
    end

    private

    # Get admin token for magento backend
    def get_admin_token
      if admin_token.nil?
        headers = { accept: :json, content_type: :json }
        @admin_token, success = post_wrapper('/V1/integration/admin/token',
                                             { username: MagentoRestApiRb.admin_login,
                                               password: MagentoRestApiRb.admin_password }.to_json,
                                             headers)

        raise Magento::Error, @admin_token.to_s unless success
      end
      admin_token
    end

    def admin_headers
      headers = { accept: :json, content_type: :json }
      get_admin_token
      headers[:authorization] = "Bearer #{admin_token}"
      headers
    end

    def parse_error(error)
      errors_response = JSON.parse(error)
    rescue JSON::ParserError => e
      error
    end

    def parse_response(response)
      JSON.parse(response.to_s, quirks_mode: true)
    end

    ##
    # All API methods return result and success status (true, false)
    def get_wrapper(url, headers)
      [parse_response(RestClient.get(resource + url, headers)), true]
    rescue RestClient::Exception => e
      [parse_error(e.response), false]
    end

    def post_wrapper(url, payload, headers)
      [parse_response(RestClient.post(resource + url, payload, headers)), true]
    rescue RestClient::Exception => e
      [parse_error(e.response), false]
    end

    def put_wrapper(url, payload, headers)
      [parse_response(RestClient.put(resource + url, payload, headers)), true]
    rescue RestClient::Exception => e
      [parse_error(e.response), false]
    end

    def delete_wrapper(url, headers)
      [parse_response(RestClient.delete(resource + url, headers)), true]
    rescue RestClient::Exception => e
      [parse_error(e.response), false]
    end

    def check_user_authorization
      raise Magento::Error, 'User not authorized' if customer_token.nil?
    end

    # Prepare search filters e.g. for products search
    def prepare_filters(filters, page, per_page, filter_group_start_index = 0)
      filter_array = []
      if filters.present?
        filters[:filter_groups].each_with_index do |filter_group, group_index|
          filter_group[:filters].each_with_index do |filter, filter_index|
            filter_string = "searchCriteria[filter_groups][#{group_index + filter_group_start_index}][filters][#{filter_index}][field]=#{filter[:field]}&"
            filter_string += "searchCriteria[filter_groups][#{group_index + filter_group_start_index}][filters][#{filter_index}][value]=#{filter[:value]}&"
            filter_string += "searchCriteria[filter_groups][#{group_index + filter_group_start_index}][filters][#{filter_index}][conditionType]=#{filter[:condition]}"
            filter_array.push(filter_string)
          end
        end

        filters[:order].each_with_index do |order, index|
          order_string = "searchCriteria[sortOrders][#{index}][field]=#{order[:field]}&"
          order_string += "searchCriteria[sortOrders][#{index}][direction]=#{order[:direction]}"
          filter_array.push(order_string)
        end
      end

      filter_array.push("searchCriteria[pageSize]=#{per_page}") if per_page.present?
      filter_array.push("searchCriteria[currentPage]=#{page}") if page.present?
      filter_array.join '&'
    end

  end

end