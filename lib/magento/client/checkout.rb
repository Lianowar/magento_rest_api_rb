module Magento
  class Client
    module Checkout

      def get_cart_total
        check_user_authorization
        get_wrapper('/V1/carts/mine/totals', default_headers)
      end

      def place_order(payment_method)
        check_user_authorization
        put_wrapper('/V1/carts/mine/order',
                    { payment_method: payment_method }.to_json,
                    default_headers)
      end

      def get_payment_methods
        check_user_authorization
        get_wrapper('/V1/carts/mine/payment-methods', default_headers)
      end

      def set_payment_method(method)
        check_user_authorization
        post_wrapper('/V1/carts/mine/set-payment-information',
                     { paymentMethod: method }.to_json,
                     default_headers)
      end

      def get_selected_payment_method
        check_user_authorization
        get_wrapper('/V1/carts/mine/selected-payment-method', default_headers)
      end

      def get_billing_address
        check_user_authorization
        get_wrapper('/V1/carts/mine/billing-address', default_headers)
      end

      def set_billing_address(address)
        check_user_authorization
        post_wrapper('/V1/carts/mine/billing-address', address.to_json, default_headers)
      end

      def get_shipment_address

      end

      def set_shipment_information(billing_address, shipment_address, method)
        check_user_authorization
        post_wrapper('/V1/carts/mine/shipping-information',
                     { addressInformation:
                           {}.merge(billing_address)
                             .merge(shipment_address)
                             .merge(method) }.to_json, default_headers)
      end

      def get_shipment_methods(address)
        check_user_authorization
        post_wrapper('/V1/carts/mine/estimate-shipping-methods', address.to_json, default_headers)
      end

      def get_available_countries
        get_wrapper('/V1/directory/countries', default_headers)
      end
    end
  end
end