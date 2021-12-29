class ContractFilter < ApplicationFilter
  self.sorters = {
    'title_asc' => { label: 'Title: A to Z', column: 'title', direction: 'asc' },
    'title_dsc' => { label: 'Title: Z to A', column: 'title', direction: 'desc' },
    'location_asc' => { label: 'Location: A to Z', column: 'end_location_name', direction: 'asc' },
    'location_dsc' => { label: 'Location: Z to A', column: 'end_location_name', direction: 'desc' },
    'price_asc' => { label: 'Price: Low to High', column: 'price', direction: 'asc' },
    'price_dsc' => { label: 'Price: High to Low', column: 'price', direction: 'desc' },
    'volume_asc' => { label: 'Volume: Low to High', column: 'price', direction: 'asc' },
    'volume_dsc' => { label: 'Volume: High to Low', column: 'price', direction: 'desc' },
    'issued_at_asc' => { label: 'Date Issued: Oldest to Newest', column: 'issued_at', direction: 'asc' },
    'issued_at_dsc' => { label: 'Date Issued: Newest to Oldest', column: 'issued_at', direction: 'desc' }
  }

  self.labels = {
    'end_location_id' => 'Location',
    'fitting_id' => 'Fitting'
  }

  facet :end_location_id, label: 'Location', array: true

  facet :fitting_id, label: 'Fitting', array: true

  self.facet_labels = {
    'end_location_id' => -> val { (Station.find_by(id: val) || Structure.find_by(id: val)).name },
    'fitting_id' => -> val { Fitting.find_by(id: val).name }
  }

  attribute :query, :string
  attribute :end_location_id, array: true, default: []
  attribute :fitting_id, array: true, default: []
  attribute :min_price, :integer
  attribute :max_price, :integer
  attribute :min_similarity, :decimal
  attribute :max_similarity, :decimal
  attribute :min_volume, :integer
  attribute :max_volume, :integer
  attribute :sort, :string, default: 'title_asc'

  self.array_attributes = %w[end_location_id fitting_id]

  attr_reader :scope

  def apply!(scope)
    @scope ||=
      begin
        scope = scope.includes(contract_fittings: :fitting)
        scope = scope.search_by_all(query) if query.present?
        scope = scope.where(end_location_id: end_location_id) if end_location_id.any?
        scope = scope.where('price >= ?', price) if min_price.present?
        scope = scope.where('price <= ?', price) if max_price.present?
        scope = scope.where('volume >= ?', price) if min_price.present?
        scope = scope.where('volume <= ?', price) if max_price.present?
        scope = scope.joins(:contract_fittings).where('contract_fittings.similarity >= ?', min_similarity) if min_similarity.present?
        scope = scope.joins(:contract_fittings).where('contract_fittings.similarity <= ?', max_similarity) if max_similarity.present?
        scope = scope.joins(contract_fittings: :fitting).where('fittings.id IN (?)', fitting_id) if fitting_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction], issued_at: :asc) if sorters[sort]
        scope
      end
  end

  def merge!(attribute, value)
    super

    send(:"#{attribute}=", value)

    @session[:filters]['Contract'].merge!(attribute => send(attribute))
  end

  def facet_items(field)
    send(:"#{field}_items") || []
  end

  def facet_item_selected?(facet, value)
    send(facet).include?(value)
  end

  def facet_active?(facet)
    send(facet).any?
  end

  def end_location_id_items
    scope.select(:end_location_id, :end_location_id)
         .pluck(:end_location_name, :end_location_id)
         .uniq
         .sort_by { |e| e.first }
  end

  def fitting_id_items
    all_fitting_ids = scope.includes(:contract_fittings).pluck(:fitting_id).compact.uniq
    Fitting.where(id: all_fitting_ids).order(:name).pluck(:name, :id)
  end
end
