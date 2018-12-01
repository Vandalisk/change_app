require 'yaml'
require 'pry'
require 'erb'

# Util for database connection
#
class ConnectionUtil
  class << self
    def db_config
      file = ERB.new(File.read('config/database.yml')).result

      YAML.safe_load(file, [], [], true)
    end
  end
end
