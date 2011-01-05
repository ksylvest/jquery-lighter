/*
 *
 * jQuery Lightbox
 *
 * Copyright 2010 Kevin Sylvestre
 *
 */

(function($) {
  
  $.fn.lightbox = function(options) {
    
    var settings = {};

    if (options) $.extend(settings, options);
    
    var dimensions = { width: 800, height: 600 };
    
    var html = '<div id="lightbox"><div class="overlay"><div class="content"></div></div></div>';
    var close = '<span class="close"></span>';
    var next = '<span class="next"></span>';
    var prev = '<span class="prev"></span>';
    
    
    $('body').append(html);

    var lightbox = $('#lightbox');
    var overlay  = $('#lightbox .overlay');
    var content  = $('#lightbox .content');

    $(this).click(function(element) {
      
      content.html(process(this.href));
      content.append(close);
      
      content.css({
        'opacity' : 0.0,
        'top'     : $(this).offset().top,
        'left'    : $(this).offset().left,
        'height'  : $(this).height(),
        'width'   : $(this).width(),
      });
      
      lightbox.show();
      
      content.animate({ 
         'opacity' : 1.0,
         'top'     : Math.round(($(window).height() - dimensions['height']) / 2),
         'left'    : Math.round(($(window).width() - dimensions['width']) / 2),
         'height'  : dimensions['height'],
         'width'   : dimensions['width'],
      });
      
      return false;
    });
    
    return this;

  };
  
  process = function(src) {
    
    var image = new Image();
    image.src = src;
    
    return $("<img />").attr({ 'src' : image.src }).css({ 'width' : 800, 'height' : 600 });
    
  };
  
}) (jQuery);