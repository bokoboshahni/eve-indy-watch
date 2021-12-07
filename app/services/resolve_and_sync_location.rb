class ResolveAndSyncLocation < ApplicationService
  def initialize(id, authorization)
    super

    @id = id
    @authorization = authorization
  end

  def call
    case id
    when 60_000_000..64_000_000
      begin
        Station.find(id)
      rescue ActiveRecord::RecordNotFound
        Station::SyncFromESI.call(id)
      end
    else
      Structure::SyncFromESI.call(id, authorization)
    end
  end

  private

  attr_reader :id, :authorization
end
