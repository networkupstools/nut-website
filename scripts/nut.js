// Hook to set the right menu entry according to the page name / href
// Also set the parent for dropdown
$(document).ready(function () {
	$(function(){
		var current_page_URL = location.href;
		$( "a" ).each(function() {
			if ($(this).attr("href") !== "#") {
				var target_URL = $(this).prop("href");
				if (target_URL == current_page_URL) {
					$('nav a').parents('li, ul').removeClass('active');
					$(this).parent('li').addClass('active');
					$(this).parents('li, ul').addClass('active');
					return false;
				}
			}
		});
	});
});
