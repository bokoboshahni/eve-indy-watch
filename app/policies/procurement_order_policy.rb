# frozen_string_literal: true

class ProcurementOrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user.admin?

      apply(join_requester_characters)
      apply(supplied_orders)
      apply(editable_user_orders)
      apply(editable_corporation_orders)
      apply(editable_alliance_orders)
      apply(alliance_requested_orders_with_alliance_visibility)
      apply(corporation_requested_orders_with_corporation_visibility)
      apply(user_requested_orders_with_alliance_visibility)
      apply(user_requested_orders_with_corporation_visibility)
      apply(other_available_orders)
    end

    private

    attr_reader :new_scope

    def apply(additional_scope)
      @new_scope = additional_scope || @new_scope
    end

    def join_requester_characters
      scope.joins('LEFT OUTER JOIN characters rc ON rc.id = requester_id')
    end

    def supplied_orders
      new_scope.where(supplier_id: user.character_id)
    end

    def editable_user_orders
      new_scope.or(scope.where(requester_id: user.character_id))
    end

    def editable_corporation_orders
      return unless role?('corporation.orders.editor')

      new_scope.or(scope.where(requester_id: user.corporation_id))
    end

    def editable_alliance_orders
      return unless role?('alliance.orders.editor')

      new_scope.or(scope.where(requester_id: user.alliance_id))
    end

    def alliance_requested_orders_with_alliance_visibility
      new_scope.or(scope.available.where(requester_id: user.alliance_id, visibility: :alliance))
    end

    def corporation_requested_orders_with_corporation_visibility
      new_scope.or(scope.available.where(requester_id: user.corporation_id, visibility: :corporation))
    end

    def user_requested_orders_with_corporation_visibility
      new_scope.or(
        scope.available
          .where(
            requester_type: 'Character',
            'rc.corporation_id' => user.corporation_id,
            visibility: :corporation
          )
      )
    end

    def user_requested_orders_with_alliance_visibility
      new_scope.or(
        scope.available
          .where(
            requester_type: 'Character',
            'rc.alliance_id' => user.alliance_id,
            visibility: :alliance
          )
      )
    end

    def other_available_orders
      new_scope.or(scope.available.where("visibility = 'everyone' OR visibility IS NULL"))
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
