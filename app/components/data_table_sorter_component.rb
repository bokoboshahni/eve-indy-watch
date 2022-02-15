# frozen_string_literal: true

class DataTableSorterComponent < ApplicationComponent
  attr_reader :name, :filter, :session

  def initialize(name:, filter:, session:)
    @name = name
    @filter = filter
    @session = session
  end

  def sorter_item_class(sorter_name)
    active = session.dig('filters', filter.filter_resource_class, 'sort') == sorter_name
    active ? 'bg-gray-100 dark:bg-zinc-100 font-medium text-gray-900 dark:text-zinc-100' : 'text-gray-500 dark:text-zinc-500'
  end
end
