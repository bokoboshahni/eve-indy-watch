# frozen_string_literal: true

class PaginatorComponent < ApplicationComponent
  delegate :pagy_link_proc, :pagy_t, :pagy_url_for, to: :helpers

  attr_reader :pagy

  def initialize(pagy:)
    @pagy = pagy
  end
end
