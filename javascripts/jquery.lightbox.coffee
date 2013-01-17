###
jQuery Lightbox
Copyright 2012 Kevin Sylvestre
###

"use strict"

$ = jQuery

class Animation
  @transitions:
    "webkitTransition": "webkitTransitionEnd"
    "mozTransition": "mozTransitionEnd"
    "msTransition": "msTransitionEnd"
    "oTransition": "oTransitionEnd"
    "transition": "transitionend"

  @transition: ($el) ->
    el = $el[0]
    return result for type, result of @transitions when el.style[type]?

  @execute: ($el, callback) ->
    transition = @transition($el)
    if transition? then $el.one(transition, callback) else callback()

class Lightbox
  @settings:
    dimensions:
      width:  920
      height: 540

  @lightbox: ($el, options = {}) ->
    data = $el.data("_lightbox") or new Lightbox($el, options)
    $el.data("_lightbox", data)
    return data

  template:
    "<div id='lightbox' class='lightbox'><div class='lightbox-overlay'></div><div class='lightbox-content'></div></div>"

  $: (selector) ->
    @$lightbox ?= $("#lightbox")
    @$lightbox.find(selector)

  constructor: ($el, settings = {}) ->
    @$el = $el
    @settings = $.extend {}, Lightbox.settings, settings

    $("body:not(:has(#lightbox))").append @template

    @$overlay = @$(".lightbox-overlay")
    @$content = @$(".lightbox-content")

    @$close = $("<a class='lightbox-close'>&times;</a>")
    @$prev = $("<a class='lightbox-prev'>&lsaquo;</a>")
    @$next = $("<a class='lightbox-next'>&rsaquo;</a>")
    @$body = $("<span class='lightbox-body'></span>")

    @align()
    @process()

  close: (event) =>
    event.preventDefault()
    event.stopPropagation()
    @$hide()

  image: (href) =>
    href.match(/\.(jpeg|jpg|jpe|gif|png|bmp)$/i)

  video: (href) =>
    href.match(/\.(webm|mov|mp4|m4v|ogg|ogv)$/i)

  type: (href = @href()) =>
    @settings.type or ("image" if @image(href)) or ("video" if @video(href))

  href: =>
    @$el.attr("href")

  process: =>
    @$contents = switch @type(href = @href())
      when "image" then $("<img />").attr(src: href)
      when "video" then $("<video />").attr(src: href)
      else $(href)
    @$contents.css @settings.dimensions
    @$body.html @$contents

  setup: =>
    @$close.on 'click', @hide

    @$content.append @$close
    @$content.append @$next
    @$content.append @$prev
    @$content.append @$body

  clear: =>
    @$close.off 'click', @hide

    @$close.detach()
    @$next.detach()
    @$prev.detach()
    @$body.detach()

  align: =>
    @$content.css
      opacity: 0.0,
      top:    @$el.offset().top
      left:   @$el.offset().left
      right:  @$el.offset().right
      bottom: @$el.offset().bottom
      height: @$el.height()
      width:  @$el.width()

  hide: =>
    @$overlay.css opacity: 0.8
    @$overlay.animate opacity: 0.0

    alpha = @clear
    omega = => @$lightbox.hide()

    alpha()

    @$content.animate(
      opacity:  0.0
      top:     @$el.offset().top
      left:    @$el.offset().left
      right:   @$el.offset().right
      bottom:  @$el.offset().bottom
      height:  @$el.height()
      width:   @$el.width()
    , @settings.duration, @settings.easing, omega)

  show: =>
    @$overlay.css opacity: 0.0
    @$overlay.animate opacity: 0.4

    alpha = => @$lightbox.show()
    omega = @setup

    alpha()

    @$content.animate(
       opacity: 1.0,
       top:     Math.round(($(window).height() - @settings.dimensions.height) / 2)
       left:    Math.round(($(window).width()  - @settings.dimensions.width ) / 2)
       bottom:  Math.round(($(window).height() + @settings.dimensions.height) / 2)
       right:   Math.round(($(window).width()  + @settings.dimensions.width ) / 2)
       height:  @settings.dimensions.height
       width:   @settings.dimensions.width
    , @settings.duration, @settings.easing, omega)

$.fn.extend
  lightbox: (option = {}) ->
    @each ->
      $this = $(@)

      options = $.extend {}, $.fn.lightbox.defaults, typeof option is "object" and option
      action = if typeof option is "string" then option else option.action
      action ?= "show"
      
      Lightbox.lightbox($this, options)[action]()

$(document).on "click", "[data-lightbox]", (event) ->
  event.preventDefault()
  event.stopPropagation()

  $(this).lightbox('show')