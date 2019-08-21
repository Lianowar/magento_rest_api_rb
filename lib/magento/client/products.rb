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
        result, status = get_wrapper('/V1/products?' + product_filters, default_headers)
        return result, status unless status
        return parse_products(result), status
      end

      # Get all filters from magento
      def get_product_filters(category_id = nil)
        get_wrapper("/V1/products/filters#{'?cat=' + category_id if category_id.present?}", default_headers)
      end

      # Get specific product by sku
      def get_product_by_sku(sku)
        result, status = get_wrapper("/V1/products/#{sku}", admin_headers)
        return result, status unless status
        return parse_product!(result), status
      end

      # Get all categories from magento
      def get_categories_list
        result, status = get_wrapper('/V1/categories', default_headers)
        return result, status unless status
        return parse_categories(result), status
      end

      ## values e.g. [13, 10, 1]
      def get_product_attribute_values(attribute_id, values = [])
        return [] unless values.present?
        result, status = get_wrapper("/V1/products/attributes/#{attribute_id}", default_headers)
        return result, status unless status
        return parse_attributes_by_values(result, values), status
      end

      private

      # Parse products hash from search products method
      def parse_products(products)
        return [] unless products['items'].present?

        result = products.dup
        result['items'].each do |item|
          parse_product!(item)
        end
        result
      end

      # Parse hash of one product
      def parse_product!(product)
        custom_attr = product.delete('custom_attributes')
        custom_attr.each do |attr|
          product[attr['attribute_code']] = attr['value']
        end
        product
      end

      # Parse categories with change input hash
      def parse_categories!(categories)
        categories['children_data'].select! do |category|
          category['is_active']
        end
        categories['children_data'].each do |category|
          parse_categories!(category)
        end
        categories['children_data']
      end

      # Parse categories list from get categories method
      def parse_categories(categories)
        categories_clone = categories.dup
        parse_categories!(categories_clone)
      end

      # Parse product option attributes and return only included in product selections
      def parse_attributes_by_values(attributes, values)
        result = []
        values = values.map(&:to_s)
        attributes['options'].each do |option|
          if values.include? option['value'].to_s
            result.push({ label: option['label'], value: option['value'] })
          end
        end
        result
      end

      # Default visibility filters for exclude
      # in search disabled products and not visibly
      def product_visibility_filters
        "searchCriteria[filter_groups][0][filters][0][field]=status&" +
        + "searchCriteria[filter_groups][0][filters][0][value]=1&" +
        + "searchCriteria[filter_groups][0][filters][0][conditionType]=eq&" +
        + "searchCriteria[filter_groups][1][filters][0][field]=visibility&" +
        + "searchCriteria[filter_groups][1][filters][0][value]=2&" +
        + "searchCriteria[filter_groups][1][filters][0][value]=3&" +
        + "searchCriteria[filter_groups][1][filters][0][value]=4&" +
        + "searchCriteria[filter_groups][1][filters][0][conditionType]=qteq&"
      end

    end
  end
end
