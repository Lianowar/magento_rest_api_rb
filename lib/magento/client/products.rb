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
      # filters = {filter_groups: [{filters: [{field: 'category_id', value: 1, condition: 'eq'}]}],
      #             {field: 'price', value: 100, condition: 'eq'}],
      #             order: [{field: 'name', direction: 'ABC'}]}
      # get_products(1, 10, filters)

      # To perform a logical OR, specify multiple filters within a filter_groups
      # To perform a logical AND, specify multiple filter_groups.
      ##=======

      def get_products(page, per_page, filters = {})
        @product_filters = prepare_filters(filters, page, per_page)
        puts product_filters
        get_wrapper('/V1/products?' + product_filters, default_headers)
      end

      def get_product_by_sku(sku)
        get_wrapper("/V1/products/#{sku}", default_headers)
      end

    end
  end
end