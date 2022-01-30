# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ERB safety' do
  Dir[Rails.root.join('app/{components,views}/**/*.{html,html+}.erb')].each do |filename|
    pathname = Pathname.new(filename).relative_path_from(Rails.root)
    describe pathname do
      it 'is parseable' do
        data = File.read(filename)
        BetterHtml::BetterErb::ErubiImplementation.new(data).validate!
      end
    end
  end
end
