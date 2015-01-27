# -*- coding: utf-8 -*-
# mongodb_admin.rb
#
# Administration of MongoDB
#
# Copyright (c) 2015 TADA Tadashi <t@tdtds.jp>
# Distributed under the GPL2 or any later version.
#

add_conf_proc( 'mongodb_admin', 'MongoDB Admin' ) do
	if @mode == 'saveconf'
		if @cgi.params['mongodb_admin.rebuild'][0] == '1'
			TDiary::IO::MongoDB::Diary.create_indexes
			TDiary::IO::MongoDB::Comment.create_indexes
			TDiary::IO::MongoDB::Plugin.create_indexes
		end
	end

	<<-HTML
	<h3>Rebuild Indexes</h3>
	<p>データベースの再インデックス化を行います。セットアップ後に1回だけ行う必要があります。</p>
	<p><label for="mongodb_admin.rebuild">
	<input type="checkbox" id="mongodb_admin.rebuild" name="mongodb_admin.rebuild" value="1">再インデックス化
	</label></p>
	HTML
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
