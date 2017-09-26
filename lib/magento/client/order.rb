module Magento
  class Client
    module Order
      def get_order_info_by_id(order_id)
        headers = { accept: :json, content_type: :json }
        get_admin_token
        headers[:authorization] = "Bearer #{admin_token}"

        get_wrapper("/V1/orders/#{order_id}", headers)
      end
    end
  end
end