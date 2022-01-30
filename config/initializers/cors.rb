# frozen_string_literal: true

if Rails.env.development?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'

      resource '*',
               headers: :any,
               methods: %i[get post put patch delete options head]
    end
  end
end
