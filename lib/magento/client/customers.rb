module Magento
  class Client
    module Customers

      def me
        JSON.parse(RestClient.get(resource + '/V1/customers/me',
                                  default_headers)).to_hashugar
      end

    end
  end
end