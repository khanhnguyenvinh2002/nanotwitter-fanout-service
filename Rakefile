$rakedb=true
require './app'
$rakedb=false
require 'sinatra/activerecord/rake'
require "sinatra/activerecord"

namespace :db do
    task :load_config do
        $rakedb=true
        require './app'
        $rakedb=false
    end
end

task :default => :test
task :test do
  Dir.glob('./test/*.rb').each { |file| require file}
end