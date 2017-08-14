## API endpoints to customers

module Magento
  class Client
    module Customers

      def customer_get_me
        return nil if customer_token.nil?
        parse_response(get_wrapper('/V1/customers/me',
                                   default_headers))
      end

      def customer_put_me(payload)
        parse_response(put_wrapper('/V1/customers/me',
                                   payload, default_headers))
      end

      def email_available?(email, website_id)
        parse_response(post_wrapper('/V1/customers/isEmailAvailable',
                                    { customerEmail: email, websiteId: website_id }.to_json,
                                    default_headers))
      end

    end
  end
end