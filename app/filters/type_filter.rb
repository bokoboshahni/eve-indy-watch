# frozen_string_literal: true

class TypeFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'name_asc', label: 'Name: A to Z', column: 'name', direction: 'asc'
  sorter 'name_dsc', label: 'Name: Z to A', column: 'name', direction: 'desc'

  facet :category_id, label: 'Category', array: true
  facet :group_id, label: 'Group', array: true
  facet :market_group_id, label: 'Market Group', array: true

  attribute :query, :string
  attribute :category_id, array: true, default: []
  attribute :group_id, array: true, default: []
  attribute :market_group_id, array: true, default: []
  attribute :sort, :string, default: 'name_asc'

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.search_by_all(query) if query.present?
        scope = scope.where(group_id:) if group_id.any?
        scope = scope.where(market_group_id:) if market_group_id.any?
        scope = scope.joins(:group).where(groups: { category_id: }) if category_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end

  def group_id_items
    Group.where(id: scope.pluck(:group_id)).distinct.order(:name).pluck(:name, :id)
  end

  def market_group_id_items
    MarketGroup.where(id: scope.pluck(:market_group_id)).distinct.order(:name).pluck(:name, :id)
  end

  def category_id_items
    Group.joins(:category).where(id: group_id_items.map(&:last)).distinct(:category_id).pluck('categories.name, category_id')
  end
end
