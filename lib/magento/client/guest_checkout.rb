module Magento
  class Client
    module GuestCheckout
      # Get total cart information with tax, shipment and items
      def get_guest_cart_total
        get_wrapper("/V1/guest-carts/#{guest_cart_key}/totals", default_headers)
      end

      # Place order for customer cart
      def place_guest_order(payment_method)
        put_wrapper("/V1/guest-carts/#{guest_cart_key}/order",
                    { payment_method: payment_method }.to_json, default_headers)
      end

      def get_guest_payment_methods
        get_wrapper("/V1/guest-carts/#{guest_cart_key}/payment-methods", default_headers)
      end

      def set_guest_payment_method(method)
        post_wrapper("/V1/guest-carts/#{guest_cart_key}/set-payment-information",
                     { paymentMethod: method }.to_json,
                     default_headers)
      end

      def get_guest_selected_payment_method
        get_wrapper("/V1/guest-carts/#{guest_cart_key}/selected-payment-method", default_headers)
      end

      def get_guest_billing_address
        get_wrapper("/V1/guest-carts/#{guest_cart_key}/billing-address", default_headers)
      end

      def set_guest_billing_address(address)
        post_wrapper("/V1/guest-carts/#{guest_cart_key}/billing-address", address.to_json, default_headers)
      end

      # Set set shipment information: address, shipment_method, biling_address
      def set_guest_shipment_information(billing_address, shipment_address, method)
        post_wrapper("/V1/guest-carts/#{guest_cart_key}/shipping-information",
                     { addressInformation:
                           {}.merge(billing_address)
                               .merge(shipment_address)
                               .merge(method) }.to_json, default_headers)
      end

      # Get shipment methods for specific shipment address
      def get_guest_shipment_methods(address)
        post_wrapper("/V1/guest-carts/#{guest_cart_key}/estimate-shipping-methods", address.to_json, default_headers)
      end
    end
  end
end