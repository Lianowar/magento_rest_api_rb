## API endpoints to customers

module Magento
  class Client
    module Customers

      attr_reader :customer_filters

      def customer_me
        check_user_authorization
        get_wrapper('/V1/customers/me', default_headers)
      end

      def edit_customer(payload)
        check_user_authorization
        put_wrapper('/V1/customers/me', payload.to_json, default_headers)
      end

      def email_available?(email)
        post_wrapper('/V1/customers/isEmailAvailable',
                     { customerEmail: email }.to_json,
                     default_headers)
      end

      def activate_customer_account(key)
        check_user_authorization
        put_wrapper('/V1/customers/me/activate',
                    { confirmationKey: key }.to_json,
                    default_headers)
      end

      def activate_customer_account_by_email(email, key)
        put_wrapper("/V1/customers/#{email}/activate",
                    { confirmationKey: key }.to_json,
                    default_headers)
      end

      def change_customer_password(old_password, new_password)
        check_user_authorization
        put_wrapper('/V1/customers/me/password',
                    { currentPassword: old_password,
                      newPassword: new_password }.to_json,
                    default_headers)
      end

      def send_reset_password_email(email, website_id)
        put_wrapper('/V1/customers/password',
                    { email: email, template: 'email_reset',
                      websiteId: website_id }.to_json,
                    default_headers)
      end

      def resend_confirmation_email(email, website_id, redirect_url)
        post_wrapper('/V1/customers/confirm',
                     { email: email, redirectUrl: redirect_url,
                       websiteId: website_id }.to_json,
                     default_headers)
      end

      def validate_password_reset_token(customer_id, reset_token)
        get_wrapper("/V1/customers/#{customer_id}/password/resetLinkToken/#{reset_token}",
                    default_headers)
      end

      def validate_customer_data(payload)
        headers = { accept: :json, content_type: :json }

        get_admin_token

        headers[:authorization] = "Bearer #{admin_token}"

        put_wrapper('/V1/customers/validate', payload.to_json, headers)
      end

      # ## Similar to products filters
      # def search_customers(page, per_page, filters = {})
      #   @customer_filters = prepare_filters(filters, page, per_page)
      #   parse_response(get_wrapper("/V1/customers/search?#{customer_filters}", default_headers))
      # end


    end
  end
end