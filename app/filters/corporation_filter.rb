# frozen_string_literal: true

class CorporationFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'name_asc', label: 'Name: A to Z', column: 'name', direction: 'asc'
  sorter 'name_dsc', label: 'Name: Z to A', column: 'name', direction: 'desc'
  sorter 'alliance_asc', label: 'Alliance: A to Z', column: 'a1.name', direction: 'asc'
  sorter 'alliance_dsc', label: 'Alliance: Z to A', column: 'a1.name', direction: 'desc'

  facet 'alliance_id', label: 'Alliance', array: true

  attribute :query, :string
  attribute :alliance_id, array: true, default: []
  attribute :sort, :string, default: 'name_asc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.joins('LEFT OUTER JOIN alliances a1 ON a1.id = corporations.alliance_id')
        scope = scope.search_by_all(query) if query.present?
        scope = scope.where(alliance_id:) if alliance_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end

  def alliance_id_items
    scope.order('a1.name').pluck('a1.name, a1.id').reject { |i| i.first.nil? }.sort_by(&:first).uniq
  end
end
