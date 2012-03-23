$(document).ready(function() {
/* toggle header visibility */
	$("#hide").toggle(function(){
		$("#header").slideUp();
		$("#hide").html('<img src="images/arrow-down.png" title="Show Header" />');
		}, function(){
		$("#header").slideDown();
		$("#hide").html('<img src="images/arrow-up.png" title="Hide Header" />');
	});
/* end */
/* displays header avatar zoom */	
	$("#modal").css({
		"background-color":"black",
		"border":"2px solid #555",
		"-webkit-box-shadow":"0px 0px 6px #000",
		"position":"absolute",
		"top":"50px",
		"left":"50px",
		"padding":"5px 5px 2px 5px",
		"-webkit-border-radius":"10px"
	}).hide();
	$("#modal img").css({"border-radius":"5px"});
	$("#frame").mouseenter(function(){
		$("#modal").addClass("focus");
		setTimeout(function(){
		if($("#modal").hasClass("focus")){
			$("#modal").fadeIn();
		}
		}, 1000 );		
	});
	$("#frame").mouseleave(function(){
		$("#modal").removeClass("focus");	
		$("#modal").fadeOut();
	});	
/* end */
});
/* load another style with jquery =  $('style[type="text/css"]').text('@import url("Variants/teste.css");'); */