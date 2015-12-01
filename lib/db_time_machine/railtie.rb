require 'db_time_machine'
require 'rails'
module YourGem
  class Railtie < Rails::Railtie
    rake_tasks do
      spec = Gem::Specification.find_by_name 'db_time_machine'
      load "#{spec.gem_dir}/lib/tasks/db_time_machine.rake"
    end
  end
end