require 'sinatra'
require 'date'
require 'json'
require 'socket'

VERSION = '4.0.0'

before do
  content_type 'application/json'
end

get '/' do
  result = { 
    :version => VERSION, 
    :ping => DateTime.now.to_s, 
    :config_location => ENV['CONFIG_LOCATION'], 
    :secrets_location => ENV['SECRETS_LOCATION'],
    :host => Socket.gethostname
  }
  result.to_json
end

get '/config' do
  return File.read(ENV['CONFIG_LOCATION']);
end

get '/secrets' do
  return File.read(ENV['SECRETS_LOCATION']);
end

get '/is-ready' do
  {
    :result => 'ready'
  }.to_json
end

get '/is-alive' do
  delay = ENV['ALIVE_DELAY'] || 3
  sleep delay.to_i
  {
    :result => 'alive!'
  }.to_json
end