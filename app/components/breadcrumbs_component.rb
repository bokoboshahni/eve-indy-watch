# frozen_string_literal: true

class BreadcrumbsComponent < ApplicationComponent
  renders_many :items, BreadcrumbItemComponent
end
