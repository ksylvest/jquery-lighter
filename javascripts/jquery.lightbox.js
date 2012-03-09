/*
 *
 * jQuery Lightbox
 *
 * Copyright 2011 Kevin Sylvestre
 *
 */

(function ($) {

  "use strict";

  $.fn.lightbox = function (options) {

    var settings = {
      duration: 600,
      easing: 'easeInOutBack',
      dimensions: {
        width:  920,
        height: 540,
      }
    };

    if (options) {
      $.extend(settings, options);
    }

    var html = '<div id="lightbox" class="lightbox"><div class="lightbox-overlay"></div><div class="lightbox-content"></div></div>';

    $('body:not(:has(#lightbox))').append(html);

    var $current;

    var $lightbox = $('#lightbox');
    var $overlay  = $('#lightbox .lightbox-overlay');
    var $content  = $('#lightbox .lightbox-content');

    var $caption = $('<div class="lightbox-caption"><p><strong>{{title}}</strong></p><p>{{details}}</p></div>')
    var $close = $('<a class="lightbox-close">&times;</a>');
    var $prev = $('<a class="lightbox-prev">&lsaquo;</a>');
    var $next = $('<a class="lightbox-next">&rsaquo;</a>');
    var $body = $('<span class="lightbox-body"></span>');


    var process = function ($element) {

      var $contents = null;

      var href = $element.attr('href');
      var type = settings['type'];

      if (href.match(/(jpeg|jpg|jpe|gif|png|bmp)$/i)) type = 'image';
      if (href.match(/(webm|mov|mp4|m4v|ogg|ogv)$/i)) type = 'video';

      switch (type)
      {
        case "image":
          $contents = $("<img />").attr({ 'src' : href });
          break;
        case "video":
          $contents = $("video />").attr({ 'src' : href });
          break;
        default:
          $contents = $(href);
          break;
      }

      $contents.css(settings['dimensions']);

      $body.html($contents);

    };


    var align = function ($element) {

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


    var setup = function () {
      $content.append($close);
      $content.append($caption);
      $content.append($next);
      $content.append($prev);
      $content.append($body);
    };


    var teardown = function () {
      $close.detach();
      $caption.detach();
      $next.detach();
      $prev.detach();
      $body.detach();
    }


    var hide = function ($element) {

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


    var show = function ($element) {

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

        $current = $(this);

        align($(this));
        show($(this));
        process($(this));
      });
    });


    $overlay.click(function (event) {
      event.preventDefault();
      hide($current);
    });


    $close.click(function (event) {
      event.preventDefault();
      hide($current);
    });


    return this;

  };

  $(function () {
    $('[data-lightbox]').lightbox();
  });
  
}) (jQuery);