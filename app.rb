require 'sinatra'
require 'date'
require 'json'
require 'socket'

VERSION = '20180323.0'

get '/' do
  result = { :version => VERSION, :ping => DateTime.now.to_s, :ip => IPSocket.getaddress(Socket.gethostname) }
  result.to_json
end
