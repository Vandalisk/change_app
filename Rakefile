require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

require 'sequel'
require 'pg'
require './lib/connection_util'

namespace :db do
  desc 'database setup'
  task :setup do
    puts 'Initialize dev database exchange_machine'

    development = db_config['development']
    test = db_config['test']

    Sequel.connect(development.merge('database' => 'postgres')) do |db|
      db.execute "DROP DATABASE IF EXISTS #{development['database']}"
      db.execute "CREATE DATABASE #{development['database']}"
    end

    puts 'Initialize test database exchange_machine'

    Sequel.connect(test.merge('database' => 'postgres')) do |db|
      db.execute "DROP DATABASE IF EXISTS #{test['database']}"
      db.execute "CREATE DATABASE #{test['database']}"
    end
  end

  desc 'seed'
  task :seed do
    coins_table = Sequel.connect(db_config['development'])[:coins]

    [50, 25, 10, 5, 2, 1].each do |value|
      coins_table.insert(value: value, count: 0)
    end
  end

  def db_config
    @db_config ||= ConnectionUtil.db_config
  end
end
