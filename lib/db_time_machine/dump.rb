module Dump

  class DatabaseConfig
    attr_accessor :host, :port, :db, :user, :password, :cmd, :file, :tables, :tmp_folder

    def initialize
      self.cmd        = nil
      self.tables     = DbTimeMachine.configuration.tables
      self.tmp_folder = DbTimeMachine.configuration.tmp_folder
      DatabaseConfig.find_config do |app, d, u, p, h, a, p1|
        self.db, self.user, self.password, self.host, self.port = d, u, p, h, p1
      end
      self.file       = File.join(tmp_folder, "#{db}_#{Time.now.to_i}.sql")
    end

    def start_dump
      puts "exporting the latest dump to #{file}"
      inprocess = File.join(tmp_folder, "dumping_data")
      `touch #{inprocess};#{cmd};rm #{inprocess}`
      while File.exist?('#{inprocess}')
        puts "database dump is in progress."
        puts "sleeping"
        sleep(0.5)
      end
      puts "database dump is complete."
    end

    def self.find_config
      yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username],
        ActiveRecord::Base.connection_config[:password],
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:port]
    end

    def self.find_adapter
      return 'mongodb' if File.exists?("#{Rails.root}/config/mongoid.yml")
      ActiveRecord::Base.connection_config[:adapter]
    end
  end

  class Mysql2 < DatabaseConfig

    def start_dump
      self.cmd = "mysqldump "
      self.cmd << "-u #{self.user} " if self.user
      self.cmd << "-p#{self.password} " if self.password
      self.cmd << "-h #{self.host} " if self.host
      self.cmd << "-P #{self.port} " if self.port
      self.cmd << "#{db} #{tables.join(' ')} > #{self.file} "
      super
    end
  end

  class Postgresql < DatabaseConfig

    def start_dump
      self.cmd = "pg_dump "
      self.cmd = "PGPASSWORD='#{self.password}' "+self.cmd if self.password
      self.cmd << "-U #{self.user} " if self.user
      self.cmd << "-h #{self.host} " if self.host
      self.cmd << "-p #{self.port} " if self.port
      self.cmd << "#{db} "
      self.cmd << "-t #{tables.join(' -t ')}" if tables.size > 0
      self.cmd << " > #{self.file} "

      super
    end
  end

  class Mongodb < DatabaseConfig

    def initialize
      self.cmd        = nil
      self.tables     = DbTimeMachine.configuration.tables
      self.tmp_folder = DbTimeMachine.configuration.tmp_folder
      Mongodb.find_config do |app, d, u, p, h, a, p1|
        self.db, self.user, self.password, self.host, self.port = d, u, p, h, p1
      end
      self.file       = File.join(tmp_folder, "#{db}_#{Time.now.to_i}")
    end

    def start_dump
      self.cmd = "mongodump "
      self.cmd << "--host #{self.host} " if self.host
      self.cmd << "--port #{self.port} " if self.port
      self.cmd << "--username #{self.user} " if self.user
      self.cmd << "--password #{self.password} " if self.password
      self.cmd << "--out #{self.file}"
      super
    end

    def self.find_config
      mongoid_config = File.read("#{Rails.root}/config/mongoid.yml")
      yield Rails.application.class.parent_name.underscore,
        YAML.load(mongoid_config)[Rails.env]["clients"]["default"]["database"],
        (YAML.load(mongoid_config)[Rails.env]["clients"]["default"]["options"]["user"] rescue nil),
        (YAML.load(mongoid_config)[Rails.env]["clients"]["default"]["options"]["password"] rescue nil),
        YAML.load(mongoid_config)[Rails.env]["clients"]["default"]["hosts"][0].split(':')[0],
        YAML.load(mongoid_config)[Rails.env]["clients"]["default"]["hosts"][0].split(':')[1]
    end
  end

end
