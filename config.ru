$:.unshift( File.join(File::expand_path(File::dirname( __FILE__ )), 'lib' ).untaint )
require 'tdiary/application'

require_relative 'lib/rack/filter'
use Rack::RedirectReverseProxy, ENV['PROXY_ADDR'] if ENV['PROXY_ADDR']

use ::Rack::Reloader unless ENV['RACK_ENV'] == 'production'
run TDiary::Application.new
