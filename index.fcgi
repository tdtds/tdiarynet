#!/usr/bin/env ruby
#
# index.fcgi $Revision: 1.35 $
#
# Copyright (C) 2004, Akinori MUSHA
# Copyright (C) 2006, moriq
# Copyright (C) 2006-2009, Kazuhiko <kazuhiko@fdiary.net>
# You can redistribute it and/or modify it under GPL2 or any later version.
#
require 'fcgi'
# workaround untaint LOAD_PATH for rubygems library path is always tainted.
$:.each{|path| path if path.include?('fcgi') }

if FileTest::symlink?( __FILE__ ) then
	org_path = File::dirname( File::readlink( __FILE__ ) )
else
	org_path = File::dirname( __FILE__ )
end
load "#{org_path}/misc/lib/fcgi_patch.rb"

FCGI.each_cgi do |cgi|
	begin
		ENV.clear
		ENV.update(cgi.env_table)
		class << CGI; self; end.class_eval do
			define_method(:new) {|*args| cgi }
		end
		dir = File::dirname( cgi.env_table["SCRIPT_FILENAME"] || __FILE__ )
		Dir.chdir(dir) do
			load 'index.rb'
		end
	ensure
		class << CGI
			remove_method :new
		end
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
