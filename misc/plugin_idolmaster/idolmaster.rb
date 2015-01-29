def comment_today; "Today's Comments&nbsp;"; end
def comment_new; 'Comment'; end
def br; '<br>'; end
def brr; '<br style="clear: right;">'; end
def brl; '<br style="clear: left;">'; end
def brb; '<br style="clear: both;">'; end

def get_thumbnail( date, para )
	thumb = ''
	diary = @diaries[date]
	return thumb unless diary

	count = 1
	diary.each_section do |sec|
		if count == para then
			if /["'][a-z][a-z](\d+)["']/ =~ sec.body then
				thumb = %Q|<img class="category-thumbnail" src="http://tn-skr1.smilevideo.jp/smile?i=#{$1}" alt="thumbnail">|
			end
			break
		end
		count += 1
	end
	return thumb
end

def category_list_items( cat, max = 5, thumb_num = 0 )
	%Q|<ul>#{category_list_items_elements( cat, max, thumb_num )}</ul>|
end

def category_list_items_elements( cat, max = 5, thumb_num = 0 )
	category = {}
	transaction('category') do |db|
		JSON.parse(db.get(key) || {}).each do |date, val|
			category[date] = val
		end
	end

	count = 0
	result = ''
	category.keys.sort.reverse_each do |date|
		category[date].reverse_each do |item|
			thumb = count < thumb_num ? get_thumbnail( date, item[0] ) : ''
			a = anchor( "#{date}##{'p%02d' % item[0]}" )
			result << %Q|<li><a href="#{a}">#{thumb}#{item[1]}</a></li>\n|
			count += 1
			break if count >= max
		end
		break if count >= max
	end
	result
end

def nicovideo_random( *videos )
	nicovideo_player( videos[rand( videos.size )] )
end

def weekly( offset, msgs )
	today = /#{%w(su m tu w th f sa)[(Time::now - offset * 3600).wday]}/
	msgs.keys.each do |w|
		return msgs[w] if today =~ w
	end
	''
end

add_header_proc do
	'<meta property="fb:page_id" content="100681086662785">'
end
