
(function ($) {
// VERTICALLY ALIGN FUNCTION
$.fn.vAlign = function() {
  return this.each(function(i){
  var ah = $(this).height();
  var ph = $(this).parent().parent().height();
  var mh = (ph - ah) / 2;
  if(mh>0) {
    $(this).css('margin-top', mh);
  } else {
    $(this).css('margin-top', 0);
  }
});
};
})(jQuery);


$(document).ready(function() {

$('.yoxview').yoxview();


// Slider  	
	if (jQuery().flexslider) {
	   $('.flexslider').flexslider({
			smoothHeight: true, 
			controlNav: true,           
			directionNav: true,  
			prevText: "&larr;",
			nextText: "&rarr;",
			selector: ".slides > .slide"
	    });
	};
    
    
    
// Smooth scrolling - css-tricks.com


});
				