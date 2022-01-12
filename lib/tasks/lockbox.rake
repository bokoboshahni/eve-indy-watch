# frozen_string_literal: true

task lockbox_key: :environment do
  puts(Lockbox.generate_key)
end
