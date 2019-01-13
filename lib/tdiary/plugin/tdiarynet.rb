#
# default plugins for tDiary.Net
#
add_footer_proc do
	footer = '<div class="footer">This Diary is Running on <a href="http://www.tdiary.net/">tDiary.Net</a> 1st server. Hosted by <a href="http://www.interlink.or.jp/service/">インターリンク</a>&nbsp;<a href="http://hosting.interlink.or.jp/">ホスティング</a></div>'

	if @conf['tdiarynet_suspended']
		footer << %Q|<div style="position:absolute;top:0px;left:0px;color:#000;background-color:#fff;padding:32px;">この日記は更新が止まっているので変更不可になっています。再度更新したい場合には<a href="http://www.tdiary.net/bbs/support.html">掲示板<a>にてその旨をお知らせ下さい。折返し管理者より連絡します。</div>|
	end

	footer
end

def clear_tdiarynet_cache(date)
	begin
		url = URI("http://proxy2.tdiary.net/cache/#{@conf.user_name}")
		params = {}
		if date
			today = date.strftime('%Y%m%d')
			this_month = today[0,6]
			days = []
			yms = []

			@years.keys.each{|y|	yms += @years[y].collect {|m| y + m}}
			yms |= [this_month]
			yms.sort!
			yms.unshift(nil).push(nil)
			yms[yms.index(this_month) - 1, 3].each do |ym|
				next unless ym
				now = @cgi.params['date'] # backup
				cgi = @cgi.clone
				cgi.params['date'] = [ym]
				m = TDiaryMonthWithoutFilter.new(cgi, '', @conf)
				@cgi.params['date'] = now # restore
				m.diaries.delete_if {|date,diary| !diary.visible?}
				days += m.diaries.keys.sort
			end
			days |= [today]
			days.sort!
			days.unshift(nil).push(nil)
			params[:date] = days[days.index(today)-1, 3].compact.join(',')
			puts "I, clear_tdiarynet_cache: clear request #{params[:date]}"
		end
		Net::HTTP::post_form(url, params)
	rescue
		puts "E, clear_tdiarynet_cache: #$!"
	end
end

case @mode
when /^(append|replace)$/
	clear_tdiarynet_cache(@date)
when /^comment$/
	date = Time.local(*(@conf.request.params['date'].scan(/(\d\d\d\d)(\d\d)(\d\d)/).flatten))
	clear_tdiarynet_cache(date)
when /^saveconf$/
	clear_tdiarynet_cache(nil)
end
