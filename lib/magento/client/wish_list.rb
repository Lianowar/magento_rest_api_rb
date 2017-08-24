module Magento
  class Client
    module WishList
      def add_item_to_wish_list(product_id)
        check_user_authorization
        post_wrapper("/V1/ipwishlist/add/#{product_id}", {}.to_json, default_headers)
      end

      def delete_item_from_wish_list(item_id)
        check_user_authorization
        delete_wrapper("/V1/ipwishlist/delete/#{item_id}", default_headers)
      end

      def get_wish_list
        check_user_authorization
        get_wrapper('/V1/ipwishlist/items', default_headers)
      end

      def get_wish_list_items_count
        check_user_authorization
        get_wrapper('/V1/ipwishlist/info', default_headers)
      end
    end
  end
end