# frozen_string_literal: true

class RegionFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'name_asc', label: 'Name: A to Z', column: 'name', direction: 'asc'
  sorter 'name_dsc', label: 'Name: Z to A', column: 'name', direction: 'desc'

  attribute :query, :string
  attribute :sort, :string, default: 'name_asc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.search_by_all(query) if query.present?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end
end
