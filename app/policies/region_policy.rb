# frozen_string_literal: true

class RegionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin? || user.role?('region.viewer')
  end

  def show?
    admin? || user.role?('region.viewer')
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
    admin? || user.role?('region.editor')
  end

  def destroy?
    false
  end

  def market_order_batches?
    admin?
  end
end
