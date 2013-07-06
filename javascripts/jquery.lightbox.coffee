###
jQuery Lightbox
Copyright 2013 Kevin Sylvestre
1.0.4
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
    padding: 40
    dimensions:
      width:  960
      height: 540

  @lightbox: ($el, options = {}) ->
    new Lightbox($el, options)

  template:
    """
    <div class='lightbox fade'>
      <div class='lightbox-container'>
        <span class='lightbox-content'></span>
        <a class='lightbox-close'>&times;</a>
        <a class='lightbox-prev'>&lsaquo;</a>
        <a class='lightbox-next'>&rsaquo;</a>
      </div>
      <div class='lightbox-overlay'></div>
    </div>
    """

  $: (selector) =>
    @$lightbox.find(selector)

  constructor: ($el, settings = {}) ->
    @$el = $el
    @settings = $.extend {}, Lightbox.settings, settings

    @$lightbox = $(@template)

    @$overlay = @$(".lightbox-overlay")
    @$content = @$(".lightbox-content")
    @$container = @$(".lightbox-container")

    @$close = @$(".lightbox-close")
    @$prev = @$(".lightbox-prev")
    @$next = @$(".lightbox-next")
    @$body = @$(".lightbox-body")

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
    omega = => @$lightbox.remove()

    alpha()
    @$lightbox.position()
    @$lightbox.addClass('fade')
    Animation.execute(@$lightbox, omega)

  show: =>
    omega = @setup
    alpha = => $(document.body).append @$lightbox

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
