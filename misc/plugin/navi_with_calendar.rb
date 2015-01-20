#
# builtin dropbox calendar into navigation bar
#

def navi
	result = %Q[<div class="adminmenu">\n]
	result << navi_user
	result << navi_admin
	result << calendar
	result << %Q[<span class="adminmenu"><a href="index.rdf"><img style="border-width: 0px;" src="http://tdiary1.tdiary.net/feed-icon-12x12.png" width="12" height="12" alt="RSS feed"></a></span>]
	result << %Q[</div>]
end

#
# short labels for smartphone
#
if @conf.smartphone? then
	def navi_index; 'TOP'; end
	def navi_prev_diary(date); '前'; end
	def navi_next_diary(date); '翌'; end
	def navi_prev_nyear(date); "前"; end
	def navi_next_nyear(date); "次"; end
	def navi_latest; '新'; end
	def navi_update; "追"; end
	def navi_edit; "編"; end
else
	def navi_prev_diary(date); '前日'; end
	def navi_next_diary(date); '翌日'; end
	def navi_prev_nyear(date); "前日"; end
	def navi_next_nyear(date); "次日"; end
end

# <br>
def br;  '<br>'; end
def brr; '<br style="clear: right;">'; end
def brl; '<br style="clear: left;">'; end
def brb; '<br style="clear: both;">'; end

