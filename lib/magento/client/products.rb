## API endpoints to products

module Magento
  class Client
    module Products

      attr_reader :product_filters

      ##=======
      # searchCriteria[filterGroups][][filters][][field] string
      # searchCriteria[filterGroups][][filters][][value] string
      # searchCriteria[filterGroups][][filters][][conditionType]
      # searchCriteria[sortOrders][][field] string
      # searchCriteria[sortOrders][][direction] string
      # searchCriteria[pageSize] integer
      # searchCriteria[currentPage] integer

      # e.g.
      # filters = {filter_groups: [{filters: [{field: 'category_id', value: 1, condition: 'eq'}],
      #             [{field: 'price', value: 100, condition: 'eq'}]}],
      #             order: [{field: 'name', direction: 'ABC'}]}
      # get_products(1, 10, filters)

      # To perform a logical OR, specify multiple filters within a filter_groups
      # To perform a logical AND, specify multiple filter_groups.
      ##=======

      def get_products(page, per_page, filters = {})
        @product_filters = product_visibility_filters + prepare_filters(filters, page, per_page, 2)
        puts product_filters
        result, status = get_wrapper('/V1/products?' + product_filters, default_headers)
        return result, status unless status
        return parse_products(result), status
      end

      def get_product_by_sku(sku)
        result, status = get_wrapper("/V1/products/#{sku}", default_headers)
        return result, status unless status
        return parse_product!(result), status
      end


      private

      def parse_products(products)
        return [] unless products['items'].present?

        result = products.dup
        result['items'].each do |item|
          parse_product!(item)
        end
        result['items']
      end

      def parse_product!(product)
        custom_attr = product.delete('custom_attributes')
        custom_attr.each do |attr|
          product[attr['attribute_code']] = attr['value']
        end
        product
      end

      def product_visibility_filters
        "searchCriteria[filter_groups][0][filters][0][field]=status&" +
        + "searchCriteria[filter_groups][0][filters][0][value]=2&" +
        + "searchCriteria[filter_groups][0][filters][0][conditionType]=eq&" +
        + "searchCriteria[filter_groups][1][filters][0][field]=visibility&" +
        + "searchCriteria[filter_groups][1][filters][0][value]=2&" +
        + "searchCriteria[filter_groups][1][filters][0][conditionType]=qteq&"
      end

    end
  end
end