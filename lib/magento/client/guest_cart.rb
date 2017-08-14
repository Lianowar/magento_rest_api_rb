module Magento
  class Client
    module GuestCart

      def create_guest_cart
        parse_response(post_wrapper('/V1/carts', {},
                                    default_headers))
      end

      def place_order_by_cart_id(cart_id, payload)
        parse_response(put_wrapper("/V1/carts/#{cart_id}/order", payload.to_json,
                                   default_headers))
      end

    end
  end
end