###
jQuery Lightbox
Copyright 2013 Kevin Sylvestre
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
      width:  960
      height: 540

  @lightbox: ($el, options = {}) ->
    new Lightbox($el, options)

  template:
    """
    <div class='lightbox fade'>
      <div class='container'>
        <span class='content'></span>
        <a class='close'>&times;</a>
        <a class='prev'>&lsaquo;</a>
        <a class='next'>&rsaquo;</a>
      </div>
      <div class='overlay'></div>
    </div>
    """

  $: (selector) =>
    @$lightbox ?= $(".lightbox")
    @$lightbox.find(selector)

  constructor: ($el, settings = {}) ->
    @$el = $el
    @settings = $.extend {}, Lightbox.settings, settings

    @$lightbox = $(@template)
    $("body").append @$lightbox

    @$overlay = @$(".overlay")
    @$content = @$(".content")
    @$container = @$(".container")

    @$close = @$(".close")
    @$prev = @$(".prev")
    @$next = @$(".next")
    @$body = @$(".body")

    @align()
    @process()

  close: (event) =>
    event.preventDefault()
    event.stopPropagation()
    @$hide()

  next: =>
    
  prev: =>
    

  image: (href) =>
    href.match(/\.(jpeg|jpg|jpe|gif|png|bmp)$/i)

  type: (href = @href()) =>
    @settings.type or ("image" if @image(href))

  href: =>
    @$el.attr("href")

  process: =>
    type = @type(href = @href())

    @$content.html switch type
      when "image" then $("<img />").attr(src: href)
      else $(href)

  resize: (width, height) =>

  setup: =>
    @$close.on "click", @hide

  clear: =>
    @$close.off "click", @hide

  align: =>
    @$container.css
      height: @settings.dimensions.height
      width:  @settings.dimensions.width
      margin: "-#{@settings.dimensions.height / 2}px -#{@settings.dimensions.width / 2}px"

  hide: =>
    alpha = @clear
    omega = => @$lightbox.hide()

    alpha()
    @$lightbox.position()
    @$lightbox.addClass('fade')
    Animation.execute(@$lightbox, omega)

  show: =>
    omega = @setup
    alpha = => @$lightbox.show()

    alpha()
    @$lightbox.position()
    @$lightbox.removeClass('fade')
    Animation.execute(@$lightbox, omega)

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

  $(this).lightbox("show")