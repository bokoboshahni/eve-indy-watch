# frozen_string_literal: true

class BreadcrumbItemComponent < ApplicationComponent
  attr_accessor :selected

  def initialize(href:)
    @href = href
  end
end
