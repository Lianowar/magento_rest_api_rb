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
      # get_products(10, 1, filters)

      # To perform a logical OR, specify multiple filters within a filter_groups
      # To perform a logical AND, specify multiple filter_groups.
      ##=======

      def get_products(per_page, page, filters = {})
        @product_filters = prepare_filters(filters, page, per_page)
        puts product_filters
        parse_response(get_wrapper('/V1/products?' + product_filters, default_headers))
      end

      def get_product_by_sku(sku)
        parse_response(get_wrapper("/V1/products/#{sku}", default_headers))
      end

      private

      def prepare_filters(filters, page, per_page)
        filter_array = []
        filters[:filter_groups].each_with_index do |filter_group, group_index|
          filter_group[:filters].each_with_index do |filter, filter_index|
            filter_string = "searchCriteria[filterGroups][#{group_index}][filters][#{filter_index}][field]=#{filter[:field]}&"
            filter_string += "searchCriteria[filterGroups][#{group_index}][filters][#{filter_index}][value]=#{filter[:value]}&"
            filter_string += "searchCriteria[filterGroups][#{group_index}][filters][#{filter_index}][conditionType]=#{filter[:condition]}"
            filter_array.push(filter_string)
          end
        end

        filters[:order].each_with_index do |order, index|
          order_string = "searchCriteria[sortOrders][#{index}][field]=#{order[:field]}&"
          order_string += "searchCriteria[sortOrders][#{index}][direction]=#{order[:direction]}"
          filter_array.push(order_string)
        end

        filter_array.push("searchCriteria[pageSize]=#{per_page}")
        filter_array.push("searchCriteria[currentPage]=#{page}")
        filter_array.join '&'
      end

    end
  end
end