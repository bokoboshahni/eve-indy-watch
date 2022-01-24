# frozen_string_literal: true

class ProcurementOrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve # rubocop:disable Metrics/AbcSize
      return scope if user.admin?

      new_scope = scope.where(requester_id: user.character_id)
      new_scope = new_scope.or(scope.where(supplier_id: user.character_id))
      new_scope = new_scope.or(scope.where(supplier_id: user.character_id, status: %i[in_progress delivered]))
      new_scope = new_scope.or(scope.where(requester_id: user.corporation_id, status: %i[in_progress unconfirmed delivered draft])) if role?('corporation.orders.editor')
      new_scope = new_scope.or(scope.where(requester_id: user.alliance_id, status: %i[in_progress unconfirmed delivered draft])) if role?('alliance.orders.editor')
      new_scope = new_scope.or(scope.available.where.not(status: :draft).where(requester_id: user.corporation_id, visibility: :corporation))
      new_scope = new_scope.or(scope.available.where.not(status: :draft).where(requester_id: user.alliance_id, visibility: :alliance))
      new_scope.or(scope.available.where.not(status: :draft).where("visibility = 'everyone' OR visibility IS NULL"))
    end
  end

  def index?
    return true if any_orders_role?

    false
  end

  def history?
    index?
  end

  def new?
    role?(/orders\.editor/)
  end

  def create?
    return true if record.requester.blank?

    return true if record.requester == user.character && role?('character.orders.editor')

    return true if record.requester == user.corporation && role?('corporation.orders.editor')

    return true if record.requester == user.alliance && role?('alliance.orders.editor')

    false
  end

  def show? # rubocop:disable Metrics/AbcSize
    return true if admin?

    return false if record.visibility == :corporation && record.requester != user.corporation

    return false if record.visibility == :alliance && record.requester != user.alliance

    return true if role?('character.orders.editor') && record.requester == user.character

    return true if role?('alliance.orders.editor') && record.requester == user.alliance

    return true if role?('corporation.orders.editor') && record.requester == user.corporation

    return false if record.draft?

    return true if any_orders_role?

    false
  end

  def update?
    return true if role?('character.orders.editor') && record.requester == user.character

    return true if role?('alliance.orders.editor') && record.requester == user.alliance

    return true if role?('corporation.orders.editor') && record.requester == user.corporation

    false
  end

  def destroy?
    update?
  end

  def accept?
    role?('character.orders.supplier')
  end

  def deliver?
    role?('character.orders.supplier') && record.supplier == user.character
  end

  def undeliver?
    record.supplier == user.character
  end

  def receive?
    update?
  end

  def redraft?
    update?
  end

  def release?
    return true if record.supplier == user.character

    false
  end

  def list_items_card?
    show?
  end

  private

  def any_orders_role?
    role?(/character\.orders/, /alliance\.orders/, /corporation\.orders/)
  end
end
