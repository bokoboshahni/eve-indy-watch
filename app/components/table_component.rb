# frozen_string_literal: true

class TableComponent < ApplicationComponent
  attr_reader :layout

  renders_many :headers, 'TableHeaderComponent'
  renders_many :rows, 'TableRowComponent'

  renders_one :head
  renders_one :body
  renders_one :foot

  def initialize(layout: 'fixed')
    @layout = layout
  end
end
