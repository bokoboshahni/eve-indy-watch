# frozen_string_literal: true

class ProcurementOrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user.admin?

      new_scope = scope.where(requester_id: user.character_id)
      new_scope = new_scope.or(scope.where(supplier_id: user.character_id, status: %i[in_progress delivered]))
      new_scope = new_scope.or(scope.where(requester_id: user.corporation_id, status: %i[in_progress delivered draft])) if role?('corporation.orders.editor')
      new_scope = new_scope.or(scope.where(requester_id: user.alliance_id, status: %i[in_progress delivered draft])) if role?('alliance.orders.editor')
      new_scope.or(scope.available.where.not(status: :draft))
    end
  end

  def index?
    return true if any_orders_role?

    false
  end

  def create?
    role?(/orders\.editor/)
  end

  def show?
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

  private

  def any_orders_role?
    role?(/character\.orders/, /alliance\.orders/, /corporation\.orders/)
  end
end
