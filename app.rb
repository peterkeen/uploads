require 'rubygems'
require 'sinatra/base'
require 'securerandom'
require 'fileutils'
require 'json'

class Uploads < Sinatra::Base

  get '/' do
    
    @existing_files = Dir.glob(File.expand_path("../public/files/*", __FILE__)).map do |dir|
      filename = Dir.glob("#{dir}/*").reject { |f| f =~ /\/(thumbnail|small)\// }[0]
      dirname = File.basename(dir)
      {
        "name" => File.basename(filename),
        "mtime" => File.mtime(filename),
        "size" => File.size?(filename),
        "url" => "http://#{ENV['ASSET_HOST'] || request.host}/files/#{dirname}/#{File.basename(filename)}"
      }
    end

    erb :index
  end

  get '/upload' do
    'hi'
  end

  post '/upload' do
    dirname = SecureRandom.hex(10)
    path = File.expand_path("../public/files/#{dirname}", __FILE__)
    FileUtils.mkdir_p(path)

    result = params['files'].map do |file|
      bytes = File.open("#{path}/#{file[:filename]}", "w+") do |f|
        f.write(file[:tempfile].read)
      end

      file_hash = {
        "name" => file[:filename],
        "size" => bytes,
        "url" => request.base_url + "/files/#{dirname}/#{file[:filename]}",
      }

    end

    {'files' => result }.to_json
    
  end
  
end
