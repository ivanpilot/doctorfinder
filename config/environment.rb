require 'bundler/setup'
Bundler.require
require 'active_support/inflector'
require 'Time'
# require 'rack/flash'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/doctors.sqlite"
)

require_all 'app'
