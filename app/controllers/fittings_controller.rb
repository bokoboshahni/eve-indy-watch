  class FittingsController < AdminController
    def index
      @pagy, @fittings = pagy(Fitting.kept.where(owner_id: main_alliance_id).order(:name))
    end

    def show
      @fitting = Fitting.find(params[:id])
    end
  end
