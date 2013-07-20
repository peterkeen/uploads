require 'rubygems'
require 'sinatra/base'
require 'httparty'

class UploadProxy < Sinatra::Base

  get '/*' do
    path = params[:splat][0]
    if !path =~ /petekeen.(com|net|org).*(js|css|woff|ttf|otf|png|ico|jpg)/
      status 404
      return "not found"
    end

    res = HTTParty.get("http://#{path}")
    content_type res.headers['Content-Type']
    response.headers['Cache-Control'] = 'public, max-age=315360000'
    response.headers['Last-Modified'] = res.headers['Last-Modified']
    response.headers['Allow-Access-Control-Origin'] = '*'
    res.body
  end
  
end
