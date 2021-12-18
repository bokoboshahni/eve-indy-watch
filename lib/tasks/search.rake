namespace :search do
  task rebuild_all: :environment do
    %w[Alliance Category Character Constellation Contract Corporation Fitting Group MarketGroup Market Region SolarSystem Station Structure Type User]
  end
end
