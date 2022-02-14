# frozen_string_literal: true

class SettingsController < ApplicationController
  def update
    if current_user.update(update_params)
      flash[:success] = 'Preferences updated successfully.'
    else
      flash[:error] = 'Error saving preferences.'
    end
    render :show
  end

  private

  def update_params
    params.require(:user).permit(:dark_mode_enabled)
  end
end
