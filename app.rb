require 'sinatra'
require 'date'
require 'json'

VERSION = '20180419.1'

before do
  content_type 'application/json'
end

get '/' do
  result = { 
    :version => VERSION, 
    :ping => DateTime.now.to_s, 
    :config_location => ENV['CONFIG_LOCATION'], 
    :secrets_location => ENV['SECRETS_LOCATION']
  }
  result.to_json
end

get '/config' do
  return File.read(ENV['CONFIG_LOCATION']);
end

get '/secrets' do
  return File.read(ENV['SECRETS_LOCATION']);
end
