require "rubygems"
require "bundler"

unless ENV["RACK_ENV"] == "production"
  require "dotenv"
  Dotenv.load
end

Bundler.require(:default, ENV.fetch("RACK_ENV", :development).to_sym)
