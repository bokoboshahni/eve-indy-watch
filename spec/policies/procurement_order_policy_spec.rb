# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcurementOrderPolicy, type: :policy do
  let(:policy) { described_class }

  let(:user) { create(:user) }

  permissions '.scope' do
    subject(:policy) { described_class::Scope.new(user, ProcurementOrder) }

    it 'includes all orders supplied by the user' do
      orders = create_list(:in_progress_order, 2, supplier: user.character)

      expect(policy.resolve).to match_array(orders)
    end

    it 'does not include orders not supplied by the user' do
      supplier = create(:character, corporation: user.corporation, alliance: user.alliance)
      create_list(:in_progress_order, 2, supplier: supplier)

      expect(policy.resolve).to be_empty
    end

    it 'includes all orders requested by the user' do
      orders = create_list(:procurement_order, 2, requester: user.character)

      expect(policy.resolve).to match_array(orders)
    end

    it 'does not include orders not requested by the user' do
      create_list(:procurement_order, 2)

      expect(policy.resolve).to be_empty
    end

    it "includes all orders requested by the user's corporation if user has corporation.orders.editor role" do
      user.update(roles: ['corporation.orders.editor'])
      orders = create_list(:procurement_order, 2, requester: user.corporation)

      expect(policy.resolve).to match_array(orders)
    end

    it "does not include orders requested by the user's corporation if user does not have corporation.orders.editor role" do
      create_list(:procurement_order, 2, requester: user.corporation)

      expect(policy.resolve).to be_empty
    end

    it "includes all orders requested by the user's alliance if user has alliance.orders.editor role" do
      user.update(roles: ['alliance.orders.editor'])
      orders = create_list(:procurement_order, 2, requester: user.alliance)

      expect(policy.resolve).to match_array(orders)
    end

    it "does not include orders requested the user's alliance if user does not have alliance.orders.editor role" do
      create_list(:procurement_order, 2, requester: user.alliance)

      expect(policy.resolve).to be_empty
    end

    it "includes available orders requested by the user's alliance with alliance visibility" do
      orders = create_list(:available_order, 2, requester: user.alliance, visibility: :alliance)

      expect(policy.resolve).to match_array(orders)
    end

    it "does not include available orders requested by an alliance other than the user's alliance with alliance visibility" do
      create_list(:available_order, 2, requester: create(:alliance), visibility: :alliance)

      expect(policy.resolve).to be_empty
    end

    it "includes available orders requested by the user's corporation with corporation visibility" do
      orders = create_list(:available_order, 2, requester: user.corporation, visibility: :corporation)

      expect(policy.resolve).to match_array(orders)
    end

    it "does not include available orders requested by a corporation other than the user's corporation with corporation visibility" do
      create_list(:available_order, 2, requester: create(:corporation), visibility: :corporation)

      expect(policy.resolve).to be_empty
    end

    it "includes available orders with alliance visibility when the requester is in the user's alliance" do
      requester = create(:character, alliance: user.alliance)
      orders = create_list(:available_order, 2, requester: requester, visibility: :alliance)

      expect(policy.resolve).to match_array(orders)
    end

    it "does not include available orders with alliance visibility when the requester is not in the user's alliance" do
      requester = create(:character)
      create_list(:available_order, 2, requester: requester, visibility: :alliance)

      expect(policy.resolve).to be_empty
    end

    it "includes available orders with corporation visibility when the requester is in the user's corporation" do
      requester = create(:character, corporation: user.corporation)
      orders = create_list(:available_order, 2, requester: requester, visibility: :corporation)

      expect(policy.resolve).to match_array(orders)
    end

    it "does not include available orders with corporation visibility when the requester is not in the user's corporation" do
      requester = create(:character)
      create_list(:available_order, 2, requester: requester, visibility: :corporation)

      expect(policy.resolve).to be_empty
    end

    it 'includes available orders with visibility to everyone' do
      orders = create_list(:available_order, 2, visibility: :everyone)

      expect(policy.resolve).to match_array(orders)
    end
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
