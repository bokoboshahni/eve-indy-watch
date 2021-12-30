class CorporationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin? || user.role?('corporation.viewer')
  end

  def show?
    admin? || user.role?('corporation.viewer')
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
    admin? || (user.role?('corporation.editor') && user.corporation_id == record.id)
  end

  def destroy?
    false
  end
end
