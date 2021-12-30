# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    include Filterable

    before_action :find_user, only: %i[destroy edit show update]

    def index
      store_filters!('User')

      scope = User.includes(:character, :corporation, :alliance)
      @filter = filter_for('User')
      @pagy, @users = pagy(@filter.apply!(scope))

      if turbo_frame_request?
        render partial: 'users', locals: { users: @users, filter: @filter, paginator: @pagy }
      else
        render :index
      end
    end

    def update
      if @user.update(user_params)
        flash[:success] = 'User updated successfully.'
        redirect_to edit_admin_user_path(@user)
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:success] = 'User deleted successfully.'
      redirect_to admin_users_path
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:admin, :esi_authorizations_enabled, roles: [])
    end
  end
end
