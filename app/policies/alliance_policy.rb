class AlliancePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin? || user.role?('alliance.viewer')
  end

  def show?
    admin? || user.role?('alliance.viewer')
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
    admin? || (user.role?('alliance.editor') && user.alliance_id == record.id)
  end

  def destroy?
    false
  end
end
