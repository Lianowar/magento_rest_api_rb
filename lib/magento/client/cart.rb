module Magento
  class Client
    module Cart
      # Get array of items from customer cart
      def get_cart_items
        check_user_authorization
        get_wrapper("/V1/carts/mine/items", default_headers)
      end

      # Add item object to customer cart
      def add_item_to_cart(item)
        check_user_authorization
        post_wrapper("/V1/carts/mine/items", item.to_json, default_headers)
      end

      # Update item qty in customer cart
      def update_item_in_cart(item_id, item)
        check_user_authorization
        put_wrapper("/V1/carts/mine/items/#{item_id}", item.to_json, default_headers)
      end

      def delete_item_from_cart(item_id)
        check_user_authorization
        delete_wrapper("/V1/carts/mine/items/#{item_id}", default_headers)
      end

      # Create cart for authorized user
      def create_cart
        check_user_authorization
        post_wrapper('/V1/carts/mine', {}.to_json, default_headers)
      end

      # Get cart form authorized user
      def get_cart
        check_user_authorization
        get_wrapper('/V1/carts/mine', default_headers)
      end

      def merge_guest_cart(guest_cart_id, customer_cart_id)
        check_user_authorization
        post_wrapper('/V1/customers/mergeguestcart',
                     { guestCartId: guest_cart_id, customerCartId: customer_cart_id }.to_json,
                     default_headers)
      end
    end
  end
end