###
jQuery Light Box
Copyright 2012 Kevin Sylvestre
###

$ = jQuery

$.fn.extend
  
  lightbox: (options) ->
    
    settings =
      duration: 600
      easing: 'easeInOutBack'
      dimensions:
        width:  800
        height: 600
    
    settings = $.extend settings, options if options
    
    html  = '<div id="lightbox"><div id="lightbox-overlay"></div><div id="lightbox-content"></div></div>'
    close = '<a id="lightbox-close">&times;</a>'
    body  = '<span id="lightbox-body"></span>'
    
    index = null
    $current = null
    
    $lightbox = $('#lightbox');
    $overlay  = $('#lightbox-overlay');
    $content  = $('#lightbox-content');
    $close    = $('#lightbox-close');
    $body     = $('#lightbox-body');