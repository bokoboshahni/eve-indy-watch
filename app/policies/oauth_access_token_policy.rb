# frozen_string_literal: true

class OauthAccessTokenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(resource_owner_id: user.id)
    end

    def index?
      true
    end

    def new?
      true
    end

    def create?
      true
    end

    def show
      record.resource_owner_id == user.id
    end

    def edit
      record.resource_owner_id == user.id
    end

    def update?
      record.resource_owner_id == user.id
    end

    def destroy?
      record.resource_owner_id == user.id
    end
  end
end
