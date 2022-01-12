# frozen_string_literal: true

class GlobalSearch < ApplicationService
  def initialize(query)
    super

    @query = query
  end

  def call
    PgSearch.multisearch(query)
            .includes(:searchable)
            .where(searchable_type: SEARCHABLE_TYPES)
            .group_by(&:searchable_type)
  end

  private

  SEARCHABLE_TYPES = %w[Contract Fitting].freeze

  attr_reader :query
end
