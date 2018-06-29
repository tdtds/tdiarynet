$:.unshift( File.join(File::expand_path(File::dirname( __FILE__ )), 'lib' ) )
require 'tdiary/application'

require 'rack/redirect_reverse_proxy'
use Rack::RedirectReverseProxy, ENV['PROXY_ADDR'] if ENV['PROXY_ADDR']

use ::Rack::Reloader unless ENV['RACK_ENV'] == 'production'
run TDiary::Application.new
