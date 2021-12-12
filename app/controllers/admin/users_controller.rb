# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :find_user, only: %i[destroy edit show update]

    def index
      @pagy, @users = pagy(User.includes(:character, :corporation, :alliance).order('characters.name asc'))
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
      params.require(:user).permit(:admin, roles: [])
    end
  end
end
