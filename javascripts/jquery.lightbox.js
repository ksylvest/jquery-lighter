/*
 *
 * jQuery Lightbox
 *
 * Copyright 2010 Kevin Sylvestre
 *
 */

(function($) {
  
  $.fn.lightbox = function(options) {
    
		
    var settings = {
      duration: 600,
      easing: 'easeInOutBack',
      dimensions: {
        width:  800,
        height: 600,
      }
    };
		
    if (options) $.extend(settings, options);
    
    var html = '<div id="lightbox"><div class="overlay"></div><div class="content"></div></div>';
    
    $('body').append(html);
    
    var index;
    var $elements = $(this)
    var $current;
		
    var $lightbox = $('#lightbox');
    var $overlay  = $('#lightbox .overlay');
    var $content  = $('#lightbox .content');
    
    var $close = $('<a class="close"></a>');
		var $body = $('<span class="body"></span>');
		
		
	  process = function($element) {
			
	    var image = new Image();
	    image.src = $element.attr('href');
			
	    var $contents = $("<img />").attr({ 'src' : image.src }).css(settings['dimensions']);
	
			$body.html($contents);
			
	  };
    
		
    align = function($element) {
      
      $content.css({
        'opacity' : 0.0,
        'top'     : $element.offset().top,
        'left'    : $element.offset().left,
        'right'   : $element.offset().right,
        'bottom'  : $element.offset().bottom,
        'height'  : $element.height(),
        'width'   : $element.width(),
      });
      
    };
    
		
    setup = function() {
      $content.append($close);
			$content.append($body);
    };
    
		
    teardown = function() {
      $close.detach();
			$body.detach();
    }
    
		
    hide = function($element) {

      $overlay.css({ 'opacity' : 0.4 });
      $overlay.animate({ 'opacity' : 0.0 });
      
      teardown();
      
      $content.animate({ 
        'opacity' : 0.0,
        'top'     : $element.offset().top,
        'left'    : $element.offset().left,
        'right'   : $element.offset().right,
        'bottom'  : $element.offset().bottom,
        'height'  : $element.height(),
        'width'   : $element.width(),
      }, settings['duration'], settings['easing'], function () { $lightbox.hide(); });

    };
    
		
    show = function($element) {

      $overlay.css({ 'opacity' : 0.0 });
      $overlay.animate({ 'opacity' : 0.4 });

      $lightbox.show();

      $content.animate({ 
         'opacity' : 1.0,
         'top'     : Math.round(($(window).height() - settings['dimensions']['height']) / 2),
         'left'    : Math.round(($(window).width()  - settings['dimensions']['width' ]) / 2),
         'bottom'  : Math.round(($(window).height() + settings['dimensions']['height']) / 2),
         'right'   : Math.round(($(window).width()  + settings['dimensions']['width' ]) / 2),
         'height'  : settings['dimensions']['height'],
         'width'   : settings['dimensions']['width' ],
      }, settings['duration'], settings['easing'], function() { setup(); });
    };
    
		
    $(this).each(function (i) {
      $(this).click(function(event) {
        event.preventDefault();
				
        index = i;
				
        $current = $(this);
				
        align($(this));
        show($(this));
				process($(this));
      });
    });
		
    
    $overlay.click(function(event) {
      event.preventDefault();
      hide($current);
    });
    
		
    $close.click(function(event) {
      event.preventDefault();
      hide($current);
    });
		
    
    return this;
		
  };
	
}) (jQuery);