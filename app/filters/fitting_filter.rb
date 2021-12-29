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
        scope = scope.search_by_all(query) if query.present?
        scope = scope.joins(:type).where('types.group_id IN (?)', group_id) if group_id.any?
        scope = scope.where(type_id: type_id) if type_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction]) if sorters[sort]
        scope
      end
  end

  def group_id_items
    Group.where(id: scope.joins(:type).pluck('types.group_id')).distinct.order(:name).pluck(:name, :id)
  end

  def type_id_items
    Type.where(id: scope.pluck(:type_id)).distinct.order(:name).pluck(:name, :id)
  end
end
