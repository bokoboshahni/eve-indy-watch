# frozen_string_literal: true

require 'down/http'

module SDE
  class DownloadSDE < ApplicationService
    SDE_ZIP_URL = 'https://eve-static-data-export.s3-eu-west-1.amazonaws.com/tranquility/sde.zip'
    SDE_CHECKSUM_URL = 'https://eve-static-data-export.s3-eu-west-1.amazonaws.com/tranquility/checksum'

    def initialize(dest_dir)
      super
      @dest_dir = dest_dir
    end

    def call
      new_checksum = Faraday.get(SDE_CHECKSUM_URL).body.strip
      if up_to_date?(new_checksum)
        info("SDE with checksum #{new_checksum} has already been downloaded")
        return
      end

      Down::Http.download(SDE_CHECKSUM_URL, destination: checksum_path)
      Down::Http.download(SDE_ZIP_URL, destination: zip_path)

      FileUtils.rm_rf(sde_path)
      Dir.chdir(dest_dir) { system('unzip sde.zip') }
    end

    private

    attr_reader :dest_dir

    def up_to_date?(new_checksum)
      return false unless File.exist?(checksum_path)

      File.read(checksum_path).strip == new_checksum
    end

    def checksum_path
      @checksum_path ||= File.join(dest_dir, 'sde.checksum.txt')
    end

    def zip_path
      @zip_path ||= File.join(dest_dir, 'sde.zip')
    end

    def sde_path
      @sde_path ||= File.join(dest_dir, 'sde')
    end
  end
end
