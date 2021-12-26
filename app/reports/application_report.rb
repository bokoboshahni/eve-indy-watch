class ApplicationReport
  class_attribute :title
  class_attribute :description

  def self.run(user, *args, **kwargs)
    started_at = Time.zone.now
    exception = nil
    results = nil
    duration = Benchmark.realtime do
      begin
        results = new(*args, **kwargs).run
      rescue StandardError => e
        exception = e
      end
    end
    status = exception ? 'error' : 'success'

    report_run = Statistics::ReportRun.create!(
      report: report_name,
      user: user,
      status: status,
      exception: exception.as_json,
      duration: duration.seconds,
      started_at: started_at
    )

    raise exception if exception

    results
  end

  def self.reports
    [
      ContractItemsInaccessibleReport
    ]
  end

  def self.report(name)
    "#{name.classify}Report".safe_constantize
  rescue KeyError
    raise ActiveRecord::RecordNotFound
  end

  def self.report_name
    name.gsub(/Report$/, '').underscore
  end

  def self.last_run
    Statistics::ReportRun.order(started_at: :desc).find_by(report: report_name)
  end
end
