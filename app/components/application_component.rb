# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers
end
