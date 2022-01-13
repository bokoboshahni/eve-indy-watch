# frozen_string_literal: true

class ApplicationPolicy
  include ServiceHelpers

  class Scope
    include ServiceHelpers

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope

    delegate :admin?, :role?, to: :user
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    admin?
  end

  def edit?
    update?
  end

  def destroy?
    admin?
  end

  delegate :admin?, :role?, to: :user
end
