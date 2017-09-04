module Magento
  class Client
    module GuestCart

      def create_guest_cart
        post_wrapper('/V1/guest-carts', {}.to_json, default_headers)
      end

      def get_guest_cart
        get_wrapper("/V1/guest-carts/#{guest_cart_key}", default_headers)
      end

      def get_guest_cart_items
        get_wrapper("/V1/guest-carts/#{guest_cart_key}/items", default_headers)
      end

      # Add item object to guest cart
      def add_item_to_guest_cart(item)
        post_wrapper("/V1/guest-carts/#{guest_cart_key}/items", item.to_json, default_headers)
      end

      # Update item qty in guest cart
      def update_item_in_guest_cart(item_id, item)
        put_wrapper("/V1/carts/#{guest_cart_key}/items/#{item_id}", item.to_json, default_headers)
      end

      def delete_item_from_guest_cart(item_id)
        delete_wrapper("/V1/guest-carts/#{guest_cart_key}/items/#{item_id}", default_headers)
      end

      def attach_guest_cart_to_customer(customer_id, store_id = MagentoRestApiRb.default_store_id)
        check_user_authorization
        put_wrapper("/V1/guest-carts/#{guest_cart_key}",
                    { customer_id: customer_id, store_id: store_id }.to_json,
                    default_headers)
      end
    end
  end
end