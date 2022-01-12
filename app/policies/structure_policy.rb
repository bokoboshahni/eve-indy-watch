# frozen_string_literal: true

class StructurePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin? || user.role?('structure.viewer')
  end

  def show?
    admin? || user.role?('structure.viewer')
  end

  def new?
    false
  end

  def create?
    false
  end

  def edit?
    update?
  end

  def update?
    admin? || (user.role?('structure.editor') && record.owner_id == user.corporation.id)
  end

  def destroy?
    false
  end

  def market_order_batches?
    admin?
  end
end
