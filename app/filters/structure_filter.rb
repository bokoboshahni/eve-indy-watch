# frozen_string_literal: true

class StructureFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'name_asc', label: 'Name: A to Z', column: 'name', direction: 'asc'
  sorter 'name_dsc', label: 'Name: Z to A', column: 'name', direction: 'desc'
  sorter 'owner_asc', label: 'Corporation: A to Z', column: 'co1.name', direction: 'asc'
  sorter 'owner_dsc', label: 'Corporation: Z to A', column: 'co1.name', direction: 'desc'
  sorter 'alliance_asc', label: 'Alliance: A to Z', column: 'a1.name', direction: 'asc'
  sorter 'alliance_dsc', label: 'Alliance: Z to A', column: 'a1.name', direction: 'desc'
  sorter 'type_asc', label: 'Type: A to Z', column: 'a1.name', direction: 'asc'
  sorter 'type_dsc', label: 'Type: Z to A', column: 'a1.name', direction: 'desc'

  facet 'alliance_id', label: 'Alliance', array: true
  facet 'owner_id', label: 'Corporation', array: true
  facet 'type_id', label: 'Type', array: true

  attribute :query, :string
  attribute :owner_id, array: true, default: []
  attribute :alliance_id, array: true, default: []
  attribute :type_id, array: true, default: []
  attribute :sort, :string, default: 'name_asc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.joins('INNER JOIN corporations co1 ON co1.id = structures.owner_id')
        scope = scope.joins('LEFT OUTER JOIN alliances a1 ON a1.id = co1.alliance_id')
        scope = scope.joins('LEFT OUTER JOIN types t1 ON t1.id = structures.type_id')
        scope = scope.search_by_all(query) if query.present?
        scope = scope.where(owner_id:) if owner_id.any?
        scope = scope.where('co1.alliance_id': alliance_id) if alliance_id.any?
        scope = scope.where(type_id:) if type_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end

  def owner_id_items
    scope.order('co1.name').pluck('co1.name, co1.id').uniq
  end

  def alliance_id_items
    scope.order('a1.name').pluck('a1.name, a1.id').reject { |i| i.first.nil? }.uniq
  end

  def type_id_items
    scope.order('t1.name').pluck('t1.name, t1.id').reject { |i| i.first.nil? }.uniq
  end
end
