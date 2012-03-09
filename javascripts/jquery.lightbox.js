
/*
jQuery Light Box
Copyright 2012 Kevin Sylvestre
*/

(function() {
  "use strict";
  var $;

  $ = jQuery;

  $.fn.extend({
    lightbox: function(options) {
      var $body, $caption, $close, $content, $current, $lightbox, $next, $overlay, $prev, align, clear, hide, html, process, settings, setup, show;
      settings = {
        duration: 600,
        easing: 'easeInOutBack',
        dimensions: {
          width: 920,
          height: 540
        }
      };
      if (options) $.extend(settings, options);
      $current = null;
      html = "<div id='lightbox' class='lightbox'><div class='lightbox-overlay'></div><div class='lightbox-content'></div></div>";
      $("body:not(:has(#lightbox))").append(html);
      $lightbox = $("#lightbox");
      $overlay = $("#lightbox .lightbox-overlay");
      $content = $("#lightbox .lightbox-content");
      $caption = $("<div class='lightbox-caption'><p><strong>{{title}}</strong></p><p>{{details}}</p></div>");
      $close = $("<a class='lightbox-close'>&times;</a>");
      $prev = $("<a class='lightbox-prev'>&lsaquo;</a>");
      $next = $("<a class='lightbox-next'>&rsaquo;</a>");
      $body = $("<span class='lightbox-body'></span>");
      process = function($element) {
        var $contents, href, type;
        $contents = null;
        href = $element.attr("href");
        type = settings["type"];
        if (href.match(/\.(jpeg|jpg|jpe|gif|png|bmp)$/i)) type = "image";
        if (href.match(/\.(webm|mov|mp4|m4v|ogg|ogv)$/i)) type = "video";
        switch (type) {
          case "image":
            $contents = $("<img  />").attr({
              src: href
            });
            break;
          case "video":
            $contents = $("video />").attr({
              src: href
            });
            break;
          default:
            $contents = $(href);
        }
        $contents.css(settings["dimensions"]);
        return $body.html($contents);
      };
      align = function($element) {
        return $content.css({
          opacity: 0.0,
          top: $element.offset().top,
          left: $element.offset().left,
          right: $element.offset().right,
          bottom: $element.offset().bottom,
          height: $element.height(),
          width: $element.width()
        });
      };
      setup = function() {
        $content.append($close);
        $content.append($next);
        $content.append($prev);
        return $content.append($body);
      };
      clear = function() {
        $close.detach();
        $next.detach();
        $prev.detach();
        return $body.detach();
      };
      hide = function($element) {
        $overlay.css({
          opacity: 0.4
        });
        $overlay.animate({
          opacity: 0.0
        });
        clear();
        return $content.animate({
          opacity: 0.0,
          top: $element.offset().top,
          left: $element.offset().left,
          right: $element.offset().right,
          bottom: $element.offset().bottom,
          height: $element.height(),
          width: $element.width()
        }, settings["duration"], settings["easing"], function() {
          return $lightbox.hide();
        });
      };
      show = function($element) {
        $overlay.css({
          opacity: 0.0
        });
        $overlay.animate({
          opacity: 0.4
        });
        $lightbox.show();
        return $content.animate({
          opacity: 1.0,
          top: Math.round(($(window).height() - settings["dimensions"]["height"]) / 2),
          left: Math.round(($(window).width() - settings["dimensions"]["width"]) / 2),
          bottom: Math.round(($(window).height() + settings["dimensions"]["height"]) / 2),
          right: Math.round(($(window).width() + settings["dimensions"]["width"]) / 2),
          height: settings["dimensions"]["height"],
          width: settings["dimensions"]["width"]
        }, settings["duration"], settings["easing"], setup);
      };
      $(this).each(function(i) {
        return $(this).click(function(event) {
          event.preventDefault();
          $current = $(this);
          align($current);
          show($current);
          return process($current);
        });
      });
      $overlay.click(function(event) {
        event.preventDefault();
        return hide($current);
      });
      $close.click(function(event) {
        event.preventDefault();
        return hide($current);
      });
      return this;
    }
  });

  $(function() {
    return $("[data-lightbox]").lightbox();
  });

}).call(this);
