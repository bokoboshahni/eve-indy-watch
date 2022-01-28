# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardComponent, type: :component do
  subject(:card_component) { described_class }

  context 'with a header' do
    it 'renders the card header' do
      header = Faker::Lorem.paragraph

      render_inline(card_component.new) do |component|
        component.header { header }
      end

      expect(rendered_component).to have_text(header)
    end
  end

  context 'with a body' do
    it 'renders the card body' do
      body = Faker::Lorem.paragraph

      render_inline(card_component.new) do |component|
        component.body { body }
      end

      expect(rendered_component).to have_text(body)
    end
  end

  context 'with a footer' do
    it 'renders the card footer' do
      footer = Faker::Lorem.paragraph

      render_inline(card_component.new) do |component|
        component.footer { footer }
      end

      expect(rendered_component).to have_text(footer)
    end
  end
end
