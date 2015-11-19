require 'sinatra'
require 'date'

get '/' do
  "ping #{DateTime.now.to_s}"
end
