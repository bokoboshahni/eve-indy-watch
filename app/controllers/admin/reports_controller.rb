module Admin
  class ReportsController < AdminController
    def index
      @reports = ApplicationReport.reports
    end

    def show
      @report = ApplicationReport.report(params[:id])
      @results = @report.run(current_user)

      render @report.name.gsub(/Report\z/, '').underscore
    end
  end
end
