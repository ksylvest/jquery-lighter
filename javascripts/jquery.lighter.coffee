###
jQuery Lighter
Copyright 2013 Kevin Sylvestre
1.0.6
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

class Lighter
  @settings:
    padding: 40
    dimensions:
      width:  960
      height: 540

  @lighter: ($el, options = {}) ->
    new Lighter($el, options)

  template:
    """
    <div class='lighter fade'>
      <div class='lighter-container'>
        <span class='lighter-content'></span>
        <a class='lighter-close'>&times;</a>
        <a class='lighter-prev'>&lsaquo;</a>
        <a class='lighter-next'>&rsaquo;</a>
      </div>
      <div class='lighter-overlay'></div>
    </div>
    """

  $: (selector) =>
    @$lighter.find(selector)

  constructor: ($el, settings = {}) ->
    @$el = $el

    if @$el.data('width')? and @$el.data('height')?
      settings.dimensions ?=
        width:  @$el.data('width')
        height: @$el.data('height')

    @settings = $.extend {}, Lighter.settings, settings

    @$lighter = $(@template)

    @$overlay = @$(".lighter-overlay")
    @$content = @$(".lighter-content")
    @$container = @$(".lighter-container")

    @$close = @$(".lighter-close")
    @$prev = @$(".lighter-prev")
    @$next = @$(".lighter-next")
    @$body = @$(".lighter-body")

    @width = @settings.dimensions.width
    @height = @settings.dimensions.height

    @align()
    @process()

  close: (event) =>
    event?.preventDefault()
    event?.stopPropagation()
    @hide()

  next: (event) =>
    event?.preventDefault()
    event?.stopPropagation()
    # TODO

  prev: =>
    event?.preventDefault()
    event?.stopPropagation()
    # TODO

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

    switch type
      when "image"
        image = new Image()
        image.src = href
        image.onload = => @resize(image.width, image.height)

  resize: (width, height) =>
    @width = width
    @height = height
    @align()

  align: =>
    ratio = Math.max ((height = @height) / ($(window).height() - @settings.padding)) , ((width  = @width ) / ($(window).width()  - @settings.padding))
    height = Math.round(height / ratio) if ratio > 1.0
    width  = Math.round(width  / ratio) if ratio > 1.0

    @$container.css
      height: height
      width: width
      margin: "-#{height / 2}px -#{width / 2}px"

  keyup: (event) =>
    return if event.target.form?
    @close() if event.which is 27 # esc
    @prev() if event.which is 37 # l-arrow
    @next() if event.which is 39 # r-arrow

  setup: =>
    $(window).on "resize", @align
    $(document).on "keyup", @keyup
    @$overlay.on "click", @close
    @$close.on "click", @close
    @$next.on "click", @next
    @$prev.on "click", @prev

  clear: =>
    $(window).off "resize", @align
    $(document).off "keyup", @keyup
    @$overlay.off "click", @close
    @$close.off "click", @close
    @$next.off "click", @next
    @$prev.off "click", @prev

  hide: =>
    alpha = @clear
    omega = => @$lighter.remove()

    alpha()
    @$lighter.position()
    @$lighter.addClass('fade')
    Animation.execute(@$lighter, omega)

  show: =>
    omega = @setup
    alpha = => $(document.body).append @$lighter

    alpha()
    @$lighter.position()
    @$lighter.removeClass('fade')
    Animation.execute(@$lighter, omega)

$.fn.extend
  lighter: (option = {}) ->
    @each ->
      $this = $(@)

      options = $.extend {}, $.fn.lighter.defaults, typeof option is "object" and option
      action = if typeof option is "string" then option else option.action
      action ?= "show"

      Lighter.lighter($this, options)[action]()

$(document).on "click", "[data-lighter]", (event) ->
  event.preventDefault()
  event.stopPropagation()

  $(this).lighter("show")
