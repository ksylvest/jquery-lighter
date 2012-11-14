###
jQuery Light Box
Copyright 2012 Kevin Sylvestre
###

"use strict"

$ = jQuery

$.fn.extend
  
  lightbox: (options) ->
    
    settings =
      duration: 
        hide: 600
        show: 600
        resize: 200
      easing:
        hide: 'easeInOutBack'
        show: 'easeInOutBack'
        resize: 'swing'
      dimensions:
        width:  920
        height: 540
    
    $.extend settings, options if options
    
    $current = null
    
    html = "<div id='lightbox' class='lightbox'><div class='lightbox-overlay'></div><div class='lightbox-content'></div></div>"
    $("body:not(:has(#lightbox))").append html
    
    $lightbox = $("#lightbox")
    $overlay = $("#lightbox .lightbox-overlay")
    $content = $("#lightbox .lightbox-content")
    
    $caption = $("<div class='lightbox-caption'><p><strong>{{title}}</strong></p><p>{{details}}</p></div>")
    $close = $("<a class='lightbox-close'>&times;</a>")
    $prev = $("<a class='lightbox-prev'>&lsaquo;</a>")
    $next = $("<a class='lightbox-next'>&rsaquo;</a>")
    $body = $("<span class='lightbox-body'></span>")
    
    process = ($element) ->
      $contents = null
      href = $element.attr("href")
      type = settings.type
      type = "image" if href.match(/\.(jpeg|jpg|jpe|gif|png|bmp)$/i)
      type = "video" if href.match(/\.(webm|mov|mp4|m4v|ogg|ogv)$/i)
      switch type
        when "image" then $contents = $("<img  />").attr(src: href)
        when "video" then $contents = $("video />").attr(src: href)
        else $contents = $(href)
      $contents.css settings.dimensions
      $body.html $contents

    resize = ->
      $content.css
        top:     Math.round(($(window).height() - settings.dimensions.height) / 2)
        left:    Math.round(($(window).width()  - settings.dimensions.width ) / 2)
        bottom:  Math.round(($(window).height() + settings.dimensions.height) / 2)
        right:   Math.round(($(window).width()  + settings.dimensions.width ) / 2)
        height:  settings.dimensions.height
        width:   settings.dimensions.width
      , settings.duration.resize, settings.easing.resize

    align = ($element) ->
      $content.css
        opacity: 0.0
        top:    $element.offset().top
        left:   $element.offset().left
        right:  $element.offset().right
        bottom: $element.offset().bottom
        height: $element.height()
        width:  $element.width()

    setup = ->
      $(window).bind "resize", resize
      
      $content.append $close
      $content.append $next
      $content.append $prev
      $content.append $body

    clear = ->
      $(window).unbind "resize", resize
    
      $close.detach()
      $next.detach()
      $prev.detach()
      $body.detach()

    hide = ($element) ->
      $overlay.css opacity: 0.4
      $overlay.animate opacity: 0.0
      
      clear()
      
      $content.animate
        opacity: 0.0
        top:    $element.offset().top
        left:   $element.offset().left
        right:  $element.offset().right
        bottom: $element.offset().bottom
        height: $element.height()
        width:  $element.width()
      , settings.duration.hide, settings.easing.hide, ->
        $lightbox.hide()

    show = ($element) ->
      $overlay.css opacity: 0.0
      $overlay.animate opacity: 0.4
      
      $lightbox.show()
      
      $content.animate
        opacity: 1.0
        top:     Math.round(($(window).height() - settings.dimensions.height) / 2)
        left:    Math.round(($(window).width()  - settings.dimensions.width ) / 2)
        bottom:  Math.round(($(window).height() + settings.dimensions.height) / 2)
        right:   Math.round(($(window).width()  + settings.dimensions.width ) / 2)
        height:  settings.dimensions.height
        width:   settings.dimensions.width
      , settings.duration.show, settings.easing.show, setup

    $(window).resize ->
      

    $(this).each (i) ->
      $(this).click (event) ->
        event.preventDefault()
        $current = $(this)
        align $current
        show $current
        process $current

    $overlay.click (event) ->
      event.preventDefault()
      hide $current

    $close.click (event) ->
      event.preventDefault()
      hide $current
        
$ ->
  $("[data-lightbox]").lightbox()
