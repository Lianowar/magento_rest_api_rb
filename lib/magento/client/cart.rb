module Magento
  class Client
    module Cart

      def get_cart_items
        check_user_authorization
        parse_response(get_wrapper("/V1/carts/mine/items",
                                   default_headers))
      end

      def add_item_to_cart(item)
        check_user_authorization
        parse_response(post_wrapper("/V1/carts/mine/items",
                                    item.to_json,
                                    default_headers))
      end

      def delete_item_from_cart(item_id)
        check_user_authorization
        parse_response(delete_wrapper("/V1/carts/mine/items/#{item_id}",
                                      default_headers))
      end

      def create_cart
        check_user_authorization
        parse_response(post_wrapper('/V1/carts/mine', {},
                                    default_headers))
      end

      def get_cart
        check_user_authorization
        parse_response(get_wrapper('/V1/carts/mine',
                                   default_headers))
      end

      def place_order_for_cart(payload)
        check_user_authorization
        parse_response(put_wrapper('/V1/carts/mine/order', payload.to_json,
                                   default_headers))
      end

    end
  end
end