require 'sinatra'
require 'date'
require 'json'

VERSION = '20171107.0'

before do
  content_type 'application/json'
end

get '/' do
  result = { :version => VERSION, :ping => DateTime.now.to_s, :config_location => ENV['CONFIG_LOCATION'] }
  result.to_json
end

get '/config' do
  return File.read(ENV['CONFIG_LOCATION']);
end