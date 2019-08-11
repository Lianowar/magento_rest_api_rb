module Magento
  class Client
    module Order

      # Get order info from magento backend by id
      def get_order_info_by_id(order_id)
        headers = admin_headers
        get_wrapper("/V1/orders/#{order_id}", headers)
      end

      def invoice_order(order_id)
        headers = admin_headers
        post_wrapper("/V1/order/#{order_id}/invoice", {}.to_json, headers)
      end

      def cancel_order(order_id)
        headers = admin_headers
        post_wrapper("/V1/orders/#{order_id}/cancel", {}.to_json, headers)
      end

      def create_a_shipment(order_id)
        headers = admin_headers
        post_wrapper("/V1/order/#{order_id}/ship", {}.to_json, headers)
      end
    end
  end
end