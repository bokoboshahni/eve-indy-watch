class MarketPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin? || user.role?('market.viewer')
  end

  def show?
    admin? || user.role?('market.viewer')
  end

  def new?
    create?
  end

  def create?
    admin? || user.role?('market.editor')
  end

  def edit?
    update?
  end

  def update?
    admin? || user.role?('market.editor')
  end

  def destroy?
    admin? || user.role?('market.editor')
  end
end
