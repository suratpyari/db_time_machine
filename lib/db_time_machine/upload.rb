class Upload

  attr_accessor :fog_connection, :fog_directory, :file

  def initialize(f)
    self.fog_connection      = DbTimeMachine.configuration.fog_connection
    self.fog_directory       = self.fog_connection.directories.get(DbTimeMachine.configuration.fog_dir)
    self.file                = f
  end

  def start
    puts "uploading data to fog directory"
    self.fog_directory.files.create(
      :key    => file.split('/').last,
      :body   => File.open(file),
      :public => false
    )
    puts "upload complate"
  end
end
