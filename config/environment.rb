require 'bundler/setup'
Bundler.require
require 'active_support/inflector'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/doctors.sqlite"
)

require_all 'app'
