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
                                   payload.to_json, default_headers))
      end

      def email_available?(email, website_id)
        parse_response(post_wrapper('/V1/customers/isEmailAvailable',
                                    { customerEmail: email, websiteId: website_id }.to_json,
                                    default_headers))
      end

      def activate_customer_account(key)
        raise 'User not authorized' if access_token.nil?
        parse_response(put_wrapper('/V1/customers/me/activate',
                                   { confirmationKey: key }.to_json,
                                   default_headers))
      end

      def activate_customer_account_by_email(email, key)
        parse_response(put_wrapper("/V1/customers/#{email}/activate",
                                   { confirmationKey: key }.to_json,
                                   default_headers))
      end

      def change_customer_password(old_password, new_password)
        parse_response(put_wrapper('/V1/customers/me/password',
                                   { currentPassword: old_password,
                                     newPassword: new_password }.to_json,
                                   default_headers))
      end

      def send_reset_password_email(email, template, website_id)
        parse_response(put_wrapper('/V1/customers/password',
                                   { email: email, template: template,
                                     websiteId: website_id }.to_json,
                                   default_headers))
      end

      def resend_confirmation_email(email, website_id, redirect_url)
        parse_response(post_wrapper('/V1/customers/confirm',
                                    { email: email, redirectUrl: redirect_url,
                                      websiteId: website_id }.to_json,
                                    default_headers))
      end

      def validate_password_reset_token(customer_id, reset_token)
        parse_response(get_wrapper("/V1/customers/#{customer_id}/password/resetLinkToken/#{reset_token}",
                                   default_headers))
      end

      def validate_customer_data(payload)
        parse_response(put_wrapper('/V1/customers/validate',
                                   payload.to_json, default_headers))
      end



    end
  end
end