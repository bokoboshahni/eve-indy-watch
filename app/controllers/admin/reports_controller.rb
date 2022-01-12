# frozen_string_literal: true

module Admin
  class ReportsController < AdminController
    def index
      @reports = ApplicationReport.reports
    end

    def show
      @report = ApplicationReport.report(params[:id])
      @results = @report.run(current_user)

      render @report.name.delete_suffix('Report').underscore
    end
  end
end
