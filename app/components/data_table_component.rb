# frozen_string_literal: true

class DataTableComponent < ApplicationComponent
  attr_reader :name, :filter, :scope

  renders_one :mobile_menu, DataTableMobileMenuComponent
  renders_one :table

  def initialize(name:, filter:, scope:)
    @name = name
    @filter = filter
    @scope = scope
  end
end
