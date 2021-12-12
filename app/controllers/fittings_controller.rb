  class FittingsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_fitting, only: %i[show edit update destroy]

    def index
      @pagy, @fittings = pagy(Fitting.kept.where(owner_id: main_alliance_id).order(:name))
    end

    def show
      @fitting = Fitting.find(params[:id])
    end

    def new
      @fitting = Fitting.new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private

    def find_fitting
      @fitting = authorize(Fitting.find(params[:id]))
    end
  end
