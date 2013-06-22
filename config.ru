require 'rubygems'
require './app'
require './proxy'
require 'rack/ssl'

use Rack::ShowExceptions

app = Uploads.new

protected_app = Rack::Auth::Basic.new(app, "Uploads") do |username, password|
  username == ENV['USERNAME'] && password == ENV['PASSWORD']
end

run Rack::URLMap.new(
  '/p' => UploadProxy.new,
  '/'  => protected_app
)
