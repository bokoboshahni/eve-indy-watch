class Order < StatisticsRecord
  class Compress < ApplicationService
    def initialize(location_id, time, delete: false)
      super

      @location_dir = Rails.root.join("tmp/orders/#{location_id}")
      @name = time.to_datetime.to_s(:number)
      @delete = delete
    end

    def call
      cmd = TTY::Command.new
      cmd.run("tar cfvj #{location_dir}/#{name}.tar.bz2 -C #{location_dir} #{name}")
      cmd.run("rm -rf #{location_dir}/#{name}") if delete
    end

    private

    attr_reader :location_dir, :name, :delete
  end
end
