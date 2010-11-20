hljs.tabReplace = '    ';
hljs.initHighlightingOnLoad();

$(function(){
    $('a.fancybox').fancybox();

    $('.archive li > ul', this).each(function(){
        var ul = $(this);

		ul.parent('li')
			.mouseenter(function(){ ul.show() })
        	.mouseleave(function(){ ul.hide() })		
        	.find('a').css('cursor', 'pointer');

        ul.hide();
    });
});
