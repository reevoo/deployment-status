require "rubygems"
require "bundler"

if %w[development test].include?(ENV["RACK_ENV"])
  require "dotenv"
  Dotenv.load
end

Bundler.require(:default, ENV.fetch("RACK_ENV", :development).to_sym)
