# frozen_string_literal: true

class ApplicationService
  include ServiceHelpers

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  def initialize(*); end
end
