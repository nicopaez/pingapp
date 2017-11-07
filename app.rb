require 'sinatra'
require 'date'
require 'json'

VERSION = '20171107.0'

get '/' do
  result = { :version => VERSION, :ping => DateTime.now.to_s }
  result.to_json
end
