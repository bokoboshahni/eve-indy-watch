# frozen_string_literal: true

class TableComponent < ApplicationComponent
  renders_many :headers, 'TableHeaderComponent'
  renders_many :rows, 'TableRowComponent'
  renders_one :body
end
