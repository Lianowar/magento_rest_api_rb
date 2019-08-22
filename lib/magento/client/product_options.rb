module Magento
  class Client
    module ProductOptions
      def product_bundle_options(product_sku)
        get_wrapper("/V1/bundle-products/#{product_sku}/options/all", default_headers)
      end

      def product_configurable_options(product_sku)

      end
    end
  end
end