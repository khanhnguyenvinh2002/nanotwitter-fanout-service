require 'sinatra'
# require 'sinatra/activerecord'
require 'bunny'
require 'json'
require "redis"

Dir[File.dirname(__FILE__) + '/config/initializers/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/api/*.rb'].each { |file| require file }
require_relative './service/redis.rb'
get '/' do
  Thread.new do
    require_relative './service/worker.rb'
  end
  erb :index
end

