require 'rubygems'
require 'capistrano-buildpack'

set :application, "bugsplat-files"
set :repository, "git@git.bugsplat.info:peter/uploads.git"
set :scm, :git
set :additional_domains, ['files.bugsplat.info']

role :web, "empoknor.bugsplat.info"
set :buildpack_url, "git@git.bugsplat.info:peter/bugsplat-buildpack-ruby-simple"

set :user, "peter"
set :base_port, 6800
set :concurrency, "web=1"

read_env 'prod'

load 'deploy'



