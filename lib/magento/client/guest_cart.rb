module Magento
  class Client
    module GuestCart

      def create_guest_cart
        post_wrapper('/V1/guest-carts', {}.to_json, default_headers)
      end

      def get_guest_cart(key)
        get_wrapper("/V1/guest-carts/#{key}", default_headers)
      end

      def place_guest_order_by_cart_id(payload, cart_key)
        put_wrapper("/V1/guest-carts/#{cart_key}/order", payload.to_json, default_headers)
      end

      def get_guest_cart_items(cart_key)
        get_wrapper("/V1/guest-carts/#{cart_key}/items", default_headers)
      end

      # Add item object to guest cart
      def add_item_to_guest_cart(item, cart_key)
        post_wrapper("/V1/guest-carts/#{cart_key}/items", item.to_json, default_headers)
      end

      # Update item qty in guest cart
      def update_item_in_guest_cart(item_id, item, cart_key)
        put_wrapper("/V1/carts/#{cart_key}/items/#{item_id}", item.to_json, default_headers)
      end

      def delete_item_from_guest_cart(item_id, cart_key)
        delete_wrapper("/V1/guest-carts/#{cart_key}/items/#{item_id}", default_headers)
      end

    end
  end
end