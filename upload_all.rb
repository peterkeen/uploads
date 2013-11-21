require 'fog'

base_dir = ARGV[0]

puts "Uploading from #{base_dir}"

@conn = Fog::Storage.new(
  provider: ENV['FOG_PROVIDER'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)

Dir.glob(base_dir + "/*") do |dir|
  filename = Dir.glob("#{dir}/*").reject { |f| f =~ /\/(thumbnail|small)\// }[0]
  next unless filename
  dirname = File.basename(dir)
  key = "files/" + File.join(dirname, File.basename(filename))

  puts key

  @conn.directories.get(ENV['FOG_DIRECTORY']).files.create(key: key, body: File.read(filename))
end
