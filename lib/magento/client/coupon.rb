# frozen_string_literal: true

module Magento
  class Client
    module Coupon

      # Add promo coupon to cart by coupon code
      def add_coupon_to_cart(coupon_code)
        check_user_authorization
        put_wrapper("/V1/carts/mine/coupons/#{coupon_code}",
                    {}.to_json, default_headers)
      end

      # Delete promo coupon from cart
      def delete_coupon_from_cart
        check_user_authorization
        delete_wrapper("/V1/carts/mine/coupons/",
                       default_headers)
      end

      # Similar to guest cart
      def add_coupon_to_guest_cart(coupon_code)
        put_wrapper("/V1/guest-carts/#{guest_cart_key}/coupons/#{coupon_code}",
                    {}.to_json, default_headers)
      end
    end
  end
end
