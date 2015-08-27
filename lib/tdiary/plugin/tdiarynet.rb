#
# default plugins for tDiary.Net
#
add_header_proc do
	%Q[<meta name="viewport" content="width=device-width,initial-scale=1">]
end

add_footer_proc do
	footer = '<div class="footer">This Diary is Running on <a href="http://www.tdiary.net/">tDiary.Net</a> 1st server. Hosted by <a href="http://www.interlink.or.jp/service/">インターリンク</a>&nbsp;<a href="http://hosting.interlink.or.jp/">ホスティング</a></div>'

	if @conf['tdiarynet_suspended']
		footer << %Q|<div style="position:absolute;top:0px;left:0px;color:#000;background-color:#fff;padding:32px;">この日記は更新が止まっているので変更不可になっています。再度更新したい場合には<a href="http://www.tdiary.net/bbs/support.html">掲示板<a>にてその旨をお知らせ下さい。折返し管理者より連絡します。</div>|
	end

	footer
end

def clear_tdiarynet_cache(date)
	begin
		url = URI("http://proxy.tdiary.net/cache/#{@conf.user_name}")
		params = date ? {date: date.strftime('%Y%m%d')} : {}
		Net::HTTP::post_form(url, params)
	rescue
		puts "clear_tdiarynet_cache: #$!"
	end
end

case @mode
when /^(append|replace)$/
	clear_tdiarynet_cache(@date)
when /^saveconf$/
	clear_tdiarynet_cache(nil)
end
