# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.new }

  permissions '.scope' do
  end

  permissions :show? do
  end

  permissions :create? do
  end

  permissions :update? do
  end

  permissions :destroy? do
  end
end
