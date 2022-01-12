# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin?
  end

  def show?
    admin?
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
    admin?
  end

  def destroy?
    admin?
  end
end
