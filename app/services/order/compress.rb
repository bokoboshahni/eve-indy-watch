class Order < StatisticsRecord
  class Compress < ApplicationService
    def initialize(location_id, time, delete: false)
      super

      @location_dir = Rails.root.join("tmp/orders/#{location_id}")
      @name = time.to_datetime.to_s(:number)
      @delete = delete
    end

    def call
      Dir.chdir(location_dir) do
        cmd = TTY::Command.new
        cmd.run("tar zcvf #{name}.tar.gz #{name}")
        cmd.run("rm -rf #{name}") if delete
      end
    end

    private

    attr_reader :location_dir, :name, :delete
  end
end
