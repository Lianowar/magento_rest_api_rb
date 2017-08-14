## Main module

require 'rest-client'
require 'json'
require 'hashugar'
require 'magento/client/customers'
require 'magento/client/products'
require 'magento/client/cart'

module Magento

  ## REST Client
  class Client

    include Magento::Client::Customers
    include Magento::Client::Products
    include Magento::Client::Cart

    attr_reader :customer_token, :default_headers, :resource, :admin_token

    def initialize(customer_token = nil, default_headers = nil)
      @customer_token = customer_token
      @default_headers = default_headers.nil? ? { accept: :json, content_type: :json } : default_headers
      @default_headers += { authorization: "Bearer #{@customer_token}" } unless @customer_token.nil?

      raise 'Has not resource host!' if MagentoRestApiRb.resource_host.nil?

      @resource = MagentoRestApiRb.resource_host
    end

    def login_customer(user_name, password)
      response = post_wrapper('/V1/integration/customer/token',
                              { "username" => user_name, "password" => password }.to_json,
                              default_headers).body
      @customer_token = JSON.parse(response)
      default_headers[:authorization] = "Bearer #{customer_token}"
      customer_token
    end

    def create_customer(customer_info, password)
      headers = { accept: :json, content_type: :json }
      get_admin_token if admin_token.nil?

      headers[:authorization] = "Bearer #{admin_token}"
      parse_response(post_wrapper('/V1/customers',
                                  { customer: customer_info,
                                    password: password }.to_json,
                                  headers))
    end


    private

    def get_admin_token
      @admin_token = JSON.parse(post_wrapper('/V1/integration/admin/token',
                                             { "username" => MagentoRestApiRb.admin_login,
                                               "password" => MagentoRestApiRb.admin_password }.to_json,
                                             headers))
    end

    def parse_response(response)
      JSON.parse(response).to_hashugar
    end

    def get_wrapper(url, headers)
      begin
        RestClient.get(resource + url, headers)
      rescue => e
        e.response
      end
    end

    def post_wrapper(url, payload, headers)
      begin
        RestClient.post(resource + url, payload, headers)
      rescue => e
        e.response
      end
    end

    def put_wrapper(url, payload, headers)
      begin
        RestClient.put(resource + url, payload, headers)
      rescue => e
        e.response
      end
    end

    def delete_wrapper(url, headers)
      begin
        RestClient.delete(resource + url, headers)
      rescue => e
        e.response
      end
    end

    def check_user_authorization
      raise 'User not authorized' if access_token.nil?
    end

    def prepare_filters(filters, page, per_page)
      filter_array = []
      if filters.present?
        filters[:filter_groups].each_with_index do |filter_group, group_index|
          filter_group[:filters].each_with_index do |filter, filter_index|
            filter_string = "searchCriteria[filterGroups][#{group_index}][filters][#{filter_index}][field]=#{filter[:field]}&"
            filter_string += "searchCriteria[filterGroups][#{group_index}][filters][#{filter_index}][value]=#{filter[:value]}&"
            filter_string += "searchCriteria[filterGroups][#{group_index}][filters][#{filter_index}][conditionType]=#{filter[:condition]}"
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