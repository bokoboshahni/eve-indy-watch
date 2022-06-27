# frozen_string_literal: true

class FittingFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'name_asc', label: 'Name: A to Z', column: 'name', direction: 'asc'
  sorter 'name_dsc', label: 'Name: Z to A', column: 'name', direction: 'desc'

  facet :group_id, label: 'Group', array: true
  facet :type_id, label: 'Ship/Structure', array: true

  attribute :query, :string
  attribute :group_id, array: true, default: []
  attribute :type_id, array: true, default: []
  attribute :sort, :string, default: 'name_asc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.joins('INNER JOIN types t1 ON t1.id = fittings.type_id')
        scope = scope.joins('INNER JOIN groups g1 ON g1.id = t1.group_id')
        scope = scope.search_by_all(query) if query.present?
        scope = scope.joins(:type).where(types: { group_id: }) if group_id.any?
        scope = scope.where(type_id:) if type_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end

  def group_id_items
    scope.order('g1.name').pluck('g1.name, g1.id').uniq
  end

  def type_id_items
    scope.order('t1.name').pluck('t1.name, t1.id').uniq
  end
end
