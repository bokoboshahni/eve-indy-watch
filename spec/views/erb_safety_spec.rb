# frozen_string_literal: true

require 'rails_helper'
require 'better_html/test_helper/safe_erb_tester'

RSpec.describe 'ERB safety' do
  include BetterHtml::TestHelper::SafeErbTester

  Dir[Rails.root.join('app/{components,views}/**/*.{html,html+}.erb')].each do |filename|
    pathname = Pathname.new(filename).relative_path_from(Rails.root)
    describe pathname do
      it 'has no missing javascript escapes' do
        assert_erb_safety(File.read(filename))
      end
    end
  end
end
