require 'app'

use Rack::ShowExceptions
run Uploads.new
