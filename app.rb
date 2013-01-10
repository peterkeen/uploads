require 'rubygems'
require 'sinatra/base'
require 'securerandom'
require 'fileutils'
require 'json'
require 'mini_magick'

class Uploads < Sinatra::Base

  def resize_image(file, path, name, dimensions)
    new_path = "#{path}/#{name}/#{file[:filename]}"
    FileUtils.mkdir_p File.dirname(new_path)
    p new_path

    image = MiniMagick::Image.read(file[:tempfile])
    image.combine_options do |command|
      command.filter("box")
      command.resize(dimensions + "^^")
      command.gravity("Center")
      command.extent(dimensions)
    end

    File.copy(image.path, new_path)
  end

  get '/' do
    
    @existing_files = Dir.glob(File.expand_path("../public/files/*", __FILE__)).map do |dir|
      filename = Dir.glob("#{dir}/*").reject { |f| f =~ /\/(thumbnail|small)\// }[0]
      dirname = File.basename(dir)
      {
        "name" => File.basename(filename),
        "mtime" => File.mtime(filename),
        "size" => File.size?(filename),
        "url" => request.base_url + "/files/#{dirname}/#{File.basename(filename)}"
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

      if file[:filename].end_with?('jpg') || file[:filename].end_with?('png')
        resize_image(file, path, "small", "640x480")
        resize_image(file, path, "thumbnail", "100x100")

        file_hash["thumbnail_url"] = request.base_url + "/files/#{dirname}/thumbnail/#{file[:filename]}"
      end

    end

    {'files' => result }.to_json
    
  end
  
end
