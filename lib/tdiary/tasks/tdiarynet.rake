require 'open-uri'

namespace :tdiarynet do
	def hconf(key, base_user = 'tdtds')
		return `heroku config:get #{key} --app tdiary-net-#{base_user}`.chomp
	end

	desc "create a diary on Heroku"
	task :create, :user, :twitter do |t, args|
		user = args[:user]
		twitter = args[:twitter]
		app = "tdiary-net-#{user}"

		sh %Q|heroku apps:create "#{app}"|

		sh %Q|heroku addons:add mongolab --app "#{app}"|
		sh %Q|heroku addons:add sendgrid --app "#{app}"|
		sh %Q|heroku addons:add logentries --app "#{app}"|
		sh %Q|heroku addons:add memcachier --app "#{app}"|

		sh %Q|heroku config:set "TDIARYNET_USER=#{user}" "TWITTER_KEY=#{hconf :TWITTER_KEY}" "TWITTER_SECRET=#{hconf :TWITTER_SECRET}" "TWITTER_NAME=#{twitter}" --app "#{app}"|
		sh %Q|heroku domains:add "#{user}.tdiary.net" --app "#{app}"|

		sh %Q|git push "git@heroku.com:#{app}.git" master:master|
		open("http://#{app}.herokuapp.com", &:read)
		sh %Q|heroku run bundle exec rake mongodb:index --app "#{app}"|
	end

	def parse_uri(mongolab_uri)
		host  = "-h #{mongolab_uri.host}:#{mongolab_uri.port || 27017}"
		db    = "-d #{mongolab_uri.path.sub(/^./, '')}"
		login = "-u #{mongolab_uri.user}" if mongolab_uri.user
		pass  = "-p #{mongolab_uri.password}" if mongolab_uri.password
		return "#{host} #{db} #{login} #{pass}"
	end

	desc "backup MongoDB data"
	task :backup, :user do |t, args|
		user = args[:user]
		mkdir_p "./data/#{user}"

		param = parse_uri(URI(hconf(:MONGOLAB_URI, user)))
		sh %Q|mongodump #{param} -o ./data/#{user}|
	end

	desc "restore data to MongoLab"
	task :restore, :user, :dir do |t, args|
		user = args[:user]
		dir  = args[:dir]
		param = parse_uri(URI(hconf(:MONGOLAB_URI, user)))

		sh %Q|mongorestore #{param} --drop #{dir}|
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
