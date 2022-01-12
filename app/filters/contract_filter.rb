# frozen_string_literal: true

class ContractFilter < ApplicationFilter
  self.sorters = {}
  self.facets = {}

  sorter 'title_asc', label: 'Title: A to Z', column: 'title', direction: 'asc'
  sorter 'title_dsc', label: 'Title: Z to A', column: 'title', direction: 'desc'
  sorter 'location_asc', label: 'Location: A to Z', column: 'end_location_name', direction: 'asc'
  sorter 'location_dsc', label: 'Location: Z to A', column: 'end_location_name', direction: 'desc'
  sorter 'price_asc', label: 'Price: Low to High', column: 'price', direction: 'asc'
  sorter 'price_dsc', label: 'Price: High to Low', column: 'price', direction: 'desc'
  sorter 'volume_asc', label: 'Volume: Low to High', column: 'price', direction: 'asc'
  sorter 'volume_dsc', label: 'Volume: High to Low', column: 'price', direction: 'desc'
  sorter 'issued_at_asc', label: 'Date Issued: Oldest to Newest', column: 'issued_at', direction: 'asc'
  sorter 'issued_at_dsc', label: 'Date Issued: Newest to Oldest', column: 'issued_at', direction: 'desc'

  facet :end_location_id, label: 'Location', array: true
  facet :fitting_id, label: 'Fitting', array: true
  facet :issuer_corporation_id, label: 'Issuer Corporation', array: true

  attribute :query, :string
  attribute :end_location_id, array: true, default: []
  attribute :fitting_id, array: true, default: []
  attribute :issuer_corporation_id, array: true, default: []
  attribute :min_price, :integer
  attribute :max_price, :integer
  attribute :min_similarity, :decimal
  attribute :max_similarity, :decimal
  attribute :min_volume, :integer
  attribute :max_volume, :integer
  attribute :sort, :string, default: 'title_asc'

  def apply!(scope) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @scope ||=
      begin
        scope = scope.includes(contract_fittings: :fitting)
        scope = scope.joins('INNER JOIN corporations ic1 ON ic1.id = contracts.issuer_corporation_id')
        scope = scope.search_by_all(query) if query.present?
        scope = scope.where(end_location_id: end_location_id) if end_location_id.any?
        scope = scope.where(issuer_corporation_id: issuer_corporation_id) if issuer_corporation_id.any?
        scope = scope.where('price >= ?', price) if min_price.present?
        scope = scope.where('price <= ?', price) if max_price.present?
        scope = scope.where('volume >= ?', price) if min_price.present?
        scope = scope.where('volume <= ?', price) if max_price.present?
        if min_similarity.present?
          scope = scope.joins(:contract_fittings).where('contract_fittings.similarity >= ?',
                                                        min_similarity)
        end
        if max_similarity.present?
          scope = scope.joins(:contract_fittings).where('contract_fittings.similarity <= ?',
                                                        max_similarity)
        end
        scope = scope.joins(contract_fittings: :fitting).where(fittings: { id: fitting_id }) if fitting_id.any?
        scope = scope.order(sorters[sort][:column] => sorters[sort][:direction], issued_at: :asc) if sorters[sort]
        scope
      end
  end

  def end_location_id_items
    scope.select(:end_location_id, :end_location_id)
         .pluck(:end_location_name, :end_location_id)
         .uniq
         .reject { |e| e.first.nil? }
         .sort_by(&:first)
  end

  def issuer_corporation_id_items
    scope.order('ic1.name').pluck('ic1.name, ic1.id').uniq
  end

  def fitting_id_items
    all_fitting_ids = scope.includes(:contract_fittings).pluck(:fitting_id).compact.uniq
    Fitting.where(id: all_fitting_ids).order(:name).pluck(:name, :id)
  end
end
