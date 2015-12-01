# DbTimeMachine

This gem takes the dump of database for a rails application and upload it to fog directory. This can be used as cron job.

## Supports

1. Mysql
2. PostgreSql
3. MongoDB

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'db_time_machine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install db_time_machine

## Usage

initialize the configuration

```ruby
# /config/initializers/db_time_machine.rb

DbTimeMachine.configure do |config|
  # Optional configuration
  # To dump only specific tables and not all the tables. default is []
  config.tables = %w(table1 table2 table3 table4)
  # Location to save the dump locally. default is /tmp
  config.tmp_folder = "/tmp"
  # Mandatory configuration
  config.fog_connection = Fog::Storage.new({
      provider: 'AWS_OR_ANY_OTHER_PROVIDER',
      aws_access_key_id: 'AK**********************',
      aws_secret_access_key: 'qwef*************************************'
    })
  # Directory must exist on provider's storage
  config.fog_dir = 'DIRECTORY_OR_BUCKET_NAME'
end

For more providers check [http://fog.io/about/provider_documentation.html]: http://fog.io/about/provider_documentation.html

```
Use following rake task to upload the dump ..
```sh
rake db_time_machine:start
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/suratpyari/db_time_machine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
