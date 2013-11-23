require 'rubygems'
require 'sinatra/base'
require 'securerandom'
require 'fileutils'
require 'json'
require 'fog'

class Uploads < Sinatra::Base

  def connection
    Fog::Storage.new(
      provider: ENV['FOG_PROVIDER'],
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  get '/' do
    @existing_files = connection.directories.get(ENV['FOG_DIRECTORY']).files.map do |file|
      filename = file.key
      {
        "name" => File.basename(filename),
        "mtime" => file.last_modified,
        "size" => file.content_length,
        "url" => "https://#{ENV['ASSET_HOST'] || request.host}/#{filename}"
      }
    end.compact

    erb :index
  end

  get '/upload' do
    'hi'
  end

  post '/upload' do
    dirname = SecureRandom.hex(10)
    path = "files/#{dirname}"

    result = params['files'].map do |file|
      fullpath = File.join(path, file[:filename])
      f = connection.directories.get(ENV['FOG_DIRECTORY']).files.create(key: fullpath, body: file[:tempfile].read)

      file_hash = {
        "name" => file[:filename],
        "size" => f.content_length,
        "url" => "http://#{ENV['ASSET_HOST'] || request.host}/#{fullpath}"
      }
    end

    {'files' => result }.to_json
    
  end

end
