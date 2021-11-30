# frozen_string_literal: true

module Admin
  class StructuresController < AdminController
    before_action :find_structure, only: %i[show edit update]

    def index
      @structures = Structure.order(:name)
    end

    def show; end

    def edit; end

    def update
      if @structure.update(structure_params)
        flash[:success] = 'Structure settings updated sucessfully.'
        redirect_to admin_structure_path(@structure)
      else
        render :edit
      end
    end

    private

    def find_structure
      @structure = Structure.find(params[:id])
    end

    def structure_params
      params.require(:structure).permit(:contract_sync_enabled, :esi_authorization_id)
    end
  end
end
