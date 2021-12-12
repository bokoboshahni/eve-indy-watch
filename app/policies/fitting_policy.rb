# frozen_string_literal: true

class FittingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin? || corporation_fittings_admin? || alliance_fittings_admin?
  end

  def new?
    admin? || corporation_fittings_admin? || alliance_fittings_admin?
  end

  def update?
    admin? || record_admin?
  end

  def edit?
    admin? || update?
  end

  def destroy?
    corporation_fittings_admin? || alliance_fittings_admin?
  end

  private

  def record_admin?
    (record.owner_id == user.corporation_id && corporation_fittings_admin?) ||
      (record.owner_id == user.alliance_id && alliance_fittings_admin?)
  end

  def corporation_fittings_admin?
    user.role?('corporation.fittings.admin')
  end

  def alliance_fittings_admin?
    user.role?('alliance.fittings.admin')
  end
end
