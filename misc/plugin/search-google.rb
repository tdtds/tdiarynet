#
# search by google
#
def search
	result = <<-TEXT
		<form method="get" action="https://www.google.co.jp/search" class="search"><div>
		<input type="hidden" name="as_sitesearch" value="#{@conf.user_name}.tdiary.net">
		<input class="text" type="text" name="as_q" value="#{show_keyword}">
		<input class="button" type="submit" value="Go">
		</div></form>
	TEXT
end
