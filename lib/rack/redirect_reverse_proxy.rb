module Rack
	class RedirectReverseProxy
		def initialize(app, address)
			@address = address
			@app = app
		end

		def call(env)
			#env.keys.sort.each{|key| p "#{key} = #{env[key]}"}
			if env['REQUEST_PATH'] !~ %r|\A/update\.rb| &&
			   @address != env['HTTP_X_FORWARDED_FOR'] &&
			   env['HTTP_REFERER'] !~ %r|\Ahttps?://tdiary-net-#{ENV['TDIARYNET_USER']}.herokuapp.com/update\.rb|
				[
					301,
					{'location' => "http://#{ENV['TDIARYNET_USER']}.tdiary.net#{env['REQUEST_PATH']}"},
					[]
				]
			else
				@app.call(env)
			end
		end
	end
end
