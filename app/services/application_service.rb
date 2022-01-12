# frozen_string_literal: true

class ApplicationService
  include ServiceHelpers

  def self.call(*args, **kwargs)
    profile_opts = kwargs.delete(:stackprof)
    if profile_opts
      StackProf.run(**profile_opts) do
        new(*args, **kwargs).call
      end
      StackProf::Report.new(Marshal.load(File.read(profile_opts[:out]))).print_text
    else
      new(*args, **kwargs).call
    end
  end

  def initialize(*_args, **kwargs)
    new_logger = kwargs.delete(:logger)
    @logger = new_logger if new_logger
  end
end
