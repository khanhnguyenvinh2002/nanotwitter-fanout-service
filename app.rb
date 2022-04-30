require 'sinatra'
require 'bunny'
require 'json'
Dir[File.dirname(__FILE__) + '/service/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/api/*.rb'].each { |file| require file }

get '/' do
  erb :index
end

