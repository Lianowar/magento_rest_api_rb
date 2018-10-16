module Magento
  class Client
    module Checkout

      # Get total cart information with tax, shipment and items
      def get_cart_total
        check_user_authorization
        get_wrapper('/V1/carts/mine/totals', default_headers)
      end

      # Place order for customer cart
      def place_order(payment_method)
        check_user_authorization
        put_wrapper('/V1/carts/mine/order',
                    { payment_method: payment_method }.to_json,
                    default_headers)
      end

      # Get payment methods for customer cart
      def get_payment_methods
        check_user_authorization
        get_wrapper('/V1/carts/mine/payment-methods', default_headers)
      end

      # Set payment method for cart
      def set_payment_method(method)
        check_user_authorization
        post_wrapper('/V1/carts/mine/set-payment-information',
                     { paymentMethod: method }.to_json,
                     default_headers)
      end

      # Set payment information for cart
      def set_payment_information(method, billing_address)
        check_user_authorization
        post_wrapper('/default/V1/carts/mine/payment-information',
                     { paymentMethod: method}.merge(billing_address).to_json,
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

      # Set set shipment information: address, shipment_method, biling_address
      def set_shipment_information(billing_address, shipment_address, method)
        check_user_authorization
        post_wrapper('/V1/carts/mine/shipping-information',
                     { addressInformation:
                           {}.merge(billing_address)
                             .merge(shipment_address)
                             .merge(method) }.to_json, default_headers)
      end

      # Get shipment methods for specific shipment address
      def get_shipment_methods(address)
        check_user_authorization
        post_wrapper('/V1/carts/mine/estimate-shipping-methods', address.to_json, default_headers)
      end

      # Get list of available countries in magento backend
      def get_available_countries
        get_wrapper('/V1/directory/countries', default_headers)
      end
    end
  end
end