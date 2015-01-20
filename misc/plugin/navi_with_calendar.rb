#
# builtin dropbox calendar into navigation bar
#

def navi
	@options['dropdown_calendar.label'] = ''
	result = %Q[<div class="adminmenu">\n]
	result << navi_user
	result << navi_admin
	unless @mode =~ /conf/
		result << calendar
		result << %Q[<span class="adminmenu"><a href="index.rdf"><img style="border-width: 0px;" src="/images/feed-icon-12x12.png" width="12" height="12" alt="RSS feed"></a></span>]
	end
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

