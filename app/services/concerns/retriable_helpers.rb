# frozen_string_literal: true

module RetriableHelpers
  extend ActiveSupport::Concern

  def with_retries(opts = {}, &)
    Retriable.retriable(opts, &)
  end
end
