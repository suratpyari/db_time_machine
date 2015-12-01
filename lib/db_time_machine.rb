require "db_time_machine/version"

module DbTimeMachine
  class Configuration
    attr_accessor :tables, :tmp_folder, :fog_connection, :fog_dir

    def initialize
      self.tables = []
      self.tmp_folder = "/tmp"
      self.fog_connection = nil
      self.fog_dir = nil
    end

  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
    raise ArgumentError.new("Fog connection not set.") unless configuration.fog_connection
    raise ArgumentError.new("Fog directory not set.") unless configuration.fog_dir
  end
  if defined?(Rails)
    require "db_time_machine/railtie"
    require "db_time_machine/dump"
    require "db_time_machine/upload"
  end
end
