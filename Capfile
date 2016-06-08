require 'rubygems'
require 'capistrano-buildpack'

set :application, "bugsplat-files"
set :repository, "git@git.zrail.net:peter/uploads.git"
set :scm, :git
set :additional_domains, ['files.bugsplat.info']

role :web, "kodos.zrail.net"
set :buildpack_url, "git@git.zrail.net:peter/bugsplat-buildpack-ruby-simple"

set :user, "peter"
set :base_port, 7000
set :concurrency, "web=1"
set :listen_address, '10.248.9.84'

read_env 'prod'

load 'deploy'

before "deploy" do
  run("mkdir -p #{shared_path}/uploaded_files")
end

after :deploy do
  run("ln -s #{shared_path}/uploaded_files #{current_path}/public/files")
end
