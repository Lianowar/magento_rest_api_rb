module Magento
  class Client
    module GuestCart

      def create_guest_cart
        post_wrapper('/V1/guest-carts', {}.to_json, default_headers)
      end

      def get_guest_cart(key)
        get_wrapper("/V1/guest-carts/#{key}", default_headers)
      end

      def place_order_by_cart_id(cart_id, payload)
        put_wrapper("/V1/carts/#{cart_id}/order", payload.to_json, default_headers)
      end

    end
  end
end