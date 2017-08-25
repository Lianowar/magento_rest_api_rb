module Magento
  class Client
    module WishList
      # Add product to customer wish list
      # pass product_id
      def add_item_to_wish_list(product_id)
        check_user_authorization
        post_wrapper("/V1/ipwishlist/add/#{product_id}", {}.to_json, default_headers)
      end

      # Delete product from customer wish list
      # pass wishlist_item_id from get wish list request
      def delete_item_from_wish_list(item_id)
        check_user_authorization
        delete_wrapper("/V1/ipwishlist/delete/#{item_id}", default_headers)
      end

      # Get array of wishlisted items for logged in customer
      def get_wish_list
        check_user_authorization
        get_wrapper('/V1/ipwishlist/items', default_headers)
      end

      # Get count of wishlisted products
      # return e.g. [{'total_items' => 3}]
      def get_wish_list_items_count
        check_user_authorization
        get_wrapper('/V1/ipwishlist/info', default_headers)
      end
    end
  end
end