require 'rubygems'
require 'sinatra/base'
require 'httparty'

class UploadProxy < Sinatra::Base

  get '/*' do
    path = params[:splat][0]
    if !path =~ /petekeen.com.*(js|css)/
      status 404
      return "not found"
    end

    res = HTTParty.get("http://#{path}")
    content_type res.headers['Content-Type']
    res.body
  end
  
end
