# frozen_string_literal: true

module RetriableHelpers
  extend ActiveSupport::Concern

  def with_retries(opts = {}, &block)
    Retriable.retriable(opts, &block)
  end
end
