module Rack
	class RedirectReverseProxy
		def initialize(app, address)
			@address = address
			@app = app
		end

		def call(env)
			#env.keys.sort.each{|key| p "#{key} = #{env[key]}"}
			if env['REQUEST_PATH'] !~ %r|\A/update\.rb| && @address == env['HTTP_X_FORWARDED_FOR']
				[
					301,
					{'location' => "http://sho.tdiary.net#{env['REQUEST_PATH']}"},
					[]
				]
			else
				@app.call(env)
			end
		end
	end
end
