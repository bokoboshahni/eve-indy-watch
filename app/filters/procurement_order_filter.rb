# frozen_string_literal: true

class ProcurementOrderFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'requester_asc', label: 'Requester: A to Z', column: 'requester_name', direction: 'asc'
  sorter 'requester_dsc', label: 'Requester: Z to A', column: 'requester_name', direction: 'desc'
  sorter 'supplier_asc', label: 'Supplier: A to Z', column: 'supplier_name', direction: 'asc'
  sorter 'supplier_dsc', label: 'Supplier: Z to A', column: 'supplier_name', direction: 'desc'
  sorter 'location_asc', label: 'Location: A to Z', column: 'locations.name', direction: 'asc'
  sorter 'location_dsc', label: 'Location: Z to A', column: 'locations.name', direction: 'desc'
  sorter 'price_asc', label: 'Price: Low to High', column: 'price', direction: 'asc'
  sorter 'price_dsc', label: 'Price: High to Low', column: 'price', direction: 'desc'
  sorter 'volume_asc', label: 'Volume: Low to High', column: 'price', direction: 'asc'
  sorter 'volume_dsc', label: 'Volume: High to Low', column: 'price', direction: 'desc'
  sorter 'published_at_asc', label: 'Date Published: Oldest to Newest', column: 'published_at', direction: 'asc'
  sorter 'published_at_dsc', label: 'Date Published: Newest to Oldest', column: 'published_at', direction: 'desc'

  attribute :query, :string
  attribute :sort, :string, default: 'published_at_dsc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.joins(:location)
        scope = scope.search_by_all(query) if query.present?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end
end
