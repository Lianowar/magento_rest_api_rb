## Main module

require 'rest-client'
require 'json'
require 'hashugar'
require 'magento/client/customers'
require 'magento/client/products'
require 'magento/client/cart'
require 'magento/client/guest_cart'
require 'magento/client/wish_list'

module Magento

  ## REST Client
  class Client

    include Magento::Client::Customers
    include Magento::Client::Products
    include Magento::Client::Cart
    include Magento::Client::GuestCart
    include Magento::Client::WishList

    attr_reader :customer_token, :default_headers, :resource, :admin_token

    def initialize(customer_token = nil, default_headers = nil)
      @customer_token = customer_token
      @default_headers = default_headers.nil? ? { accept: :json, content_type: :json } : default_headers
      @default_headers[:authorization] = "Bearer #{@customer_token}" unless @customer_token.nil?

      raise 'Has not resource host!' if MagentoRestApiRb.resource_host.nil?

      @resource = MagentoRestApiRb.resource_host
    end

    def login_customer(user_name, password)
      token_result, success = post_wrapper('/V1/integration/customer/token',
                              { "username" => user_name, "password" => password }.to_json,
                              default_headers)
      @customer_token = token_result if success
      default_headers[:authorization] = "Bearer #{customer_token}" if success
      return token_result, success
    end

    def create_customer(customer_info, password)
      headers = { accept: :json, content_type: :json }

      get_admin_token

      headers[:authorization] = "Bearer #{admin_token}"
      post_wrapper('/V1/customers',
                   { customer: customer_info,
                     password: password }.to_json,
                   headers)
    end


    private

    def get_admin_token
      if admin_token.nil?
        headers = { accept: :json, content_type: :json }
        @admin_token, success = post_wrapper('/V1/integration/admin/token',
                                             { "username" => MagentoRestApiRb.admin_login,
                                               "password" => MagentoRestApiRb.admin_password }.to_json,
                                             headers)

        raise @admin_token.to_s unless success
      end
      admin_token
    end

    def parse_error(error)
      puts error
      messages = JSON.parse(error).to_hashugar
      messages.message.to_s.gsub(/(%[^ ]*)/, '%s') % messages.parameters
    end

    def parse_response(response)
      JSON.parse(response)
    end

    ##
    # All API methods return result and success status (true, false)
    def get_wrapper(url, headers)
      begin
        return parse_response(RestClient.get(resource + url, headers)), true
      rescue => e
        return parse_error(e.response), false
      end
    end

    def post_wrapper(url, payload, headers)
      begin
        return parse_response(RestClient.post(resource + url, payload, headers)), true
      rescue => e
        return parse_error(e.response), false
      end
    end

    def put_wrapper(url, payload, headers)
      begin
        return parse_response(RestClient.put(resource + url, payload, headers)), true
      rescue => e
        return parse_error(e.response), false
      end
    end

    def delete_wrapper(url, headers)
      begin
        return parse_response(RestClient.delete(resource + url, headers)), true
      rescue => e
        return parse_error(e.response), false
      end
    end

    def check_user_authorization
      raise 'User not authorized' if customer_token.nil?
    end

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

      filter_array.push("searchCriteria[pageSize]=#{per_page}")
      filter_array.push("searchCriteria[currentPage]=#{page}")
      filter_array.join '&'
    end

  end

end