###
jQuery Lighter
Copyright 2013 Kevin Sylvestre
1.0.9
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

  @lighter: ($el, options = {}) ->
    data = $el.data('_lighter')
    unless data
      data = new Lighter($el, options)
      $el.data('_lighter', data)
    return data

  $: (selector) =>
    @$lighter.find(selector)

  constructor: ($el, settings = {}) ->
    @$el = $el

    if @$el.data('width')? and @$el.data('height')?
      settings.dimensions ?=
        width:  @$el.data('width')
        height: @$el.data('height')

    @settings = $.extend {}, Lighter.settings, settings

    @$lighter = $(@settings.template)

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

  toggle: (method = 'on') =>
    $(window)[method] "resize", @align
    $(document)[method] "keyup", @keyup
    @$overlay[method] "click", @close
    @$close[method] "click", @close
    @$next[method] "click", @next
    @$prev[method] "click", @prev

  hide: =>
    alpha = => @toggle('off')
    omega = => @$lighter.remove()

    alpha()
    @$lighter.removeClass('fade')
    @$lighter.position()
    @$lighter.addClass('fade')
    Animation.execute(@$container, omega)

  show: =>
    omega = => @toggle('on')
    alpha = => $(document.body).append @$lighter

    alpha()
    @$lighter.addClass('fade')
    @$lighter.position()
    @$lighter.removeClass('fade')
    Animation.execute(@$container, omega)

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

  $(this).lighter()
