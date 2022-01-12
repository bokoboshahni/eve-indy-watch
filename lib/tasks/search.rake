# frozen_string_literal: true

namespace :search do
  task rebuild_all: :environment do
    %w[Alliance Category Character Constellation Contract Corporation Fitting Group MarketGroup Market Region
       SolarSystem Station Structure Type User].each do |class_name|
      RebuildMultisearchIndexWorker.perform_async(class_name)
    end
  end
end
