# -*- coding: utf-8 -*-
require 'tdiary/application'
require 'tdiary/rack/auth/omniauth'
require 'memcachier'
require 'dalli'
require 'rack/session/dalli'

TDiary::Application.configure do
	config.builder do
		use ::Rack::Session::Dalli, cache: Dalli::Client.new, expire_after: 2592000
		use OmniAuth::Builder do
			configure {|conf| conf.path_prefix = "/auth" }
			provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
		end

		map('/auth') do
			run TDiary::Rack::Auth::OmniAuth::CallbackHandler.new
		end
	end

	config.authenticate TDiary::Rack::Auth::OmniAuth, :twitter do |auth|
		# TODO: an user can setting
		auth.info.nickname == ENV['TWITTER_NAME']
	end
end
