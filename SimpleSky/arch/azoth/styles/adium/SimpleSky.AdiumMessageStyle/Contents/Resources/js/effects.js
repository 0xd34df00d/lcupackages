$(document).ready(function() {
/* toggle header visibility */
	$("#header").toggle(function(){
		$(this).fadeTo("slow", 0.0);
		$("#var-picker").fadeOut();
	}, function(){
		$(this).fadeTo("slow", 1.0);
		$("#var-picker").fadeIn();
	});	
/* end */
/* zoom avatar */
	$("#avatar-zoom img").css({"-webkit-border-radius":"5px"});
	$("#avatar-zoom").css({"position":"fixed", "z-index":"105px", "width":"108px", "height":"108px", "border":"4px solid #fff", "top":"15px", "left":"25px", "-webkit-border-radius":"9px", "-webkit-box-shadow":"1px 1px 5px 0px #333"}).hide();
	$("#img-mask").mouseenter(function(){
		$("#avatar-zoom").addClass("focus");
		setTimeout(function(){
		if($("#avatar-zoom").hasClass("focus")){
			$("#avatar-zoom").fadeIn();
		}
		}, 1000 );		
	});
	$("#img-mask").mouseleave(function(){
		$("#avatar-zoom").removeClass("focus");	
		$("#avatar-zoom").fadeOut();
	});
/* end */
/* variants box display */
	$("#variants-box").hide();
	$("#var-picker img").toggle(function(){
		$("#variants-box").fadeIn();
	}, function(){
		$("#variants-box").fadeOut();
	});	
	$("body").click(function(){
		$("#variants-box").fadeOut();	
	});
/* end */

/* choose variants */
	$("#variants-box a").hover(function(){
		$(this).css({"border-color":"#fff"});
	}, function(){
		$(this).css({"border-color":"#bfdcf0"});
	});
	$("#variants-box a").click(function(){
		var theme = $(this).attr("id");
		$('style[type="text/css"]').text('@import url("Variants/' + theme + '.css");');
		return false;
	});
/* end */	
	
});
/* load another style with jquery =  $('style[type="text/css"]').text('@import url("Variants/teste.css");'); */