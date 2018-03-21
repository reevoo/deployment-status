require "rubygems"
require "bundler"

begin
  require "dotenv"
  Dotenv.load
rescue LoadError => e
  raise e unless ENV["RACK_ENV"] == "production"
end

Bundler.require(:default, ENV.fetch("RACK_ENV", :development).to_sym)

# def glob_require(dir)
#   Dir["#{App.root}/#{dir}/**/*.rb"].sort.each { |f| require f }
# end

# glob_require("config/initializers")
# glob_require("lib")
# glob_require("app")

# require "#{App.root}/config/routes"

require "./app"
run App
