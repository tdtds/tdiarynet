#
# image_tdiarynet.rb : make link to images on tDiary.Net like image plugin
#
# DO NOT USE WITH image plugin
#

add_body_enter_proc do |date|
   @image_date = date.strftime( "%Y%m%d" )
   ""
end

def image_url(date, id)
	"http://userimages.tdiary.net/#{@conf.user_name}/#{date}_#{h id}.jpg"
end

def image(id, alt = 'image', thumbnail = nil, size = nil, place = 'photo')
	image = image_url(@image_date, id)
	image_t = image_url(@image_date, thumbnail) if thumbnail

	if @cgi.smartphone?
		size = ''
	elsif size
		if size.kind_of?(Array)
			if size.length > 1
				size = %Q| width="#{h size[0]}" height="#{h size[1]}"|
			elsif size.length > 0
				size = %Q| width="#{h size[0]}"|
			end
		else
			size = %Q| width="#{size.to_i}"|
		end
	end
	if thumbnail then
	  	%Q[<a href="#{h image}"><img class="#{h place}" src="#{h image_t}" alt="#{h alt}" title="#{h alt}"#{size}></a>]
	else
		%Q[<img class="#{h place}" src="#{h image}" alt="#{h alt}" title="#{h alt}"#{size}>]
	end
end

def image_left(id, alt = "image", thumbnail = nil, width = nil)
   image(id, alt, thumbnail, width, "left")
end

def image_right(id, alt = "image", thumbnail = nil, width = nil)
   image(id, alt, thumbnail, width, "right")
end

def image_link(id, desc)
   %Q[<a href="#{image_url(@image_date, id)}">#{desc}</a>]
end
