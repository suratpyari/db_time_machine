namespace :db_time_machine do
  desc "upload database dump to s3"
  task start: :environment do
    dump = eval("Dump::#{Dump::DatabaseConfig.find_adapter.capitalize}.new()")
    dump.start_dump
    `tar -zcvf #{dump.file}.tar.gz #{dump.file}`
    upload = Upload.new(dump.file+".tar.gz")
    upload.start
    `rm -r #{dump.file} #{dump.file}.tar.gz`
  end

end
