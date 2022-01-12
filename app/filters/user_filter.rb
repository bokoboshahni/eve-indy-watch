# frozen_string_literal: true

class UserFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'name_asc', label: 'Name: A to Z', column: 'ch1.name', direction: 'asc'
  sorter 'name_dsc', label: 'Name: Z to A', column: 'ch1.name', direction: 'desc'
  sorter 'corporation_asc', label: 'Corporation: A to Z', column: 'co1.name', direction: 'asc'
  sorter 'corporation_dsc', label: 'Corporation: Z to A', column: 'co1.name', direction: 'desc'
  sorter 'alliance_asc', label: 'Alliance: A to Z', column: 'a1.name', direction: 'asc'
  sorter 'alliance_dsc', label: 'Alliance: Z to A', column: 'a1.name', direction: 'desc'

  facet 'alliance_id', label: 'Alliance', array: true
  facet 'corporation_id', label: 'Corporation', array: true

  attribute :query, :string
  attribute :corporation_id, array: true, default: []
  attribute :alliance_id, array: true, default: []
  attribute :sort, :string, default: 'name_asc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.joins('INNER JOIN characters ch1 ON ch1.id = character_id')
        scope = scope.joins('INNER JOIN alliances a1 ON a1.id = ch1.alliance_id')
        scope = scope.joins('INNER JOIN corporations co1 ON co1.id = ch1.corporation_id')
        scope = scope.search_by_all(query) if query.present?
        scope = scope.where('ch1.corporation_id': corporation_id) if corporation_id.any?
        scope = scope.where('ch1.alliance_id': alliance_id) if alliance_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end

  def corporation_id_items
    scope.order('co1.name').pluck('co1.name, co1.id').uniq
  end

  def alliance_id_items
    scope.order('a1.name').pluck('a1.name, a1.id').uniq
  end
end
