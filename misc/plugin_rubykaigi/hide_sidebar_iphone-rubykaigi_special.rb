# hide_sidebar_iphone.rb
#
# Copyright (C) 2008 SHIBATA Hiroshi <shibata.hiroshi@gmail.com>
# You can redistribute it and/or modify it under GPL2.
#

add_header_proc do
	if @conf.iphone? then
		<<-CSS
		<style type="text/css"><!--
		body {
			margin: 0px;
			padding: 0px;
		}
		div.logo {
			width: 100%;
			margin: 0px;
			padding: 0px;
		}
		div.sidebar { 
			display: none;
		}
		div.main {
			width: 100%;
			float: none;
			margin: 0px;
		}
		div.day {
			width: 100%;
			float: none;
			margin: 0px;
			padding: 0px;
		}
		--></style>
		CSS
	end
end
