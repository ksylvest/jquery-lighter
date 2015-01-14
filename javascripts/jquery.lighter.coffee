###
jQuery Lighter
Copyright 2015 Kevin Sylvestre
1.2.5
###

"use strict"

$ = jQuery

class Animation
  @transitions:
    "webkitTransition": "webkitTransitionEnd"
    "mozTransition": "mozTransitionEnd"
    "oTransition": "oTransitionEnd"
    "transition": "transitionend"

  @transition: ($el) ->
    el = $el[0]
    return result for type, result of @transitions when el.style[type]?

  @execute: ($el, callback) ->
    transition = @transition($el)
    if transition? then $el.one(transition, callback) else callback()

class Lighter
  @namespace: "lighter"

  defaults:
    padding: 40
    dimensions:
      width:  480
      height: 480
    template:
      """
      <div class='#{Lighter.namespace} fade'>
        <div class='#{Lighter.namespace}-container'>
          <span class='#{Lighter.namespace}-content'></span>
          <a class='#{Lighter.namespace}-close'>&times;</a>
          <a class='#{Lighter.namespace}-prev'>&lsaquo;</a>
          <a class='#{Lighter.namespace}-next'>&rsaquo;</a>
        </div>
        <div class='#{Lighter.namespace}-overlay'></div>
      </div>
      """

  @lighter: ($target, options = {}) ->
    data = $target.data('_lighter')
    $target.data('_lighter', data = new Lighter($target, options)) unless data
    return data

  $: (selector) =>
    @$el.find(selector)

  constructor: ($target, settings = {}) ->
    @$target = $target

    @settings = $.extend {}, @defaults, settings

    @$el = $(@settings.template)

    @$overlay = @$(".#{Lighter.namespace}-overlay")
    @$content = @$(".#{Lighter.namespace}-content")
    @$container = @$(".#{Lighter.namespace}-container")
    @$close = @$(".#{Lighter.namespace}-close")
    @$prev = @$(".#{Lighter.namespace}-prev")
    @$next = @$(".#{Lighter.namespace}-next")
    @$body = @$(".#{Lighter.namespace}-body")

    @dimensions = @settings.dimensions

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

  type: (href = @href()) =>
    @settings.type or ("image" if @href().match(/\.(webp|jpeg|jpg|jpe|gif|png|bmp)$/i))

  href: =>
    @$target.attr("href")

  process: =>
    type = @type(href = @href())

    @$content.html switch type
      when "image" then $("<img />").attr(src: href)
      else $(href)

    switch type
      when "image"
        @preload(href)

  preload: (href) =>
    image = new Image()
    image.src = href
    image.onload = => 
      @resize
        width: image.width
        height: image.height

  resize: (dimensions) =>
    @dimensions = dimensions
    @align()

  align: =>
    size = @size()

    @$container.css
      height: size.height
      width: size.width
      margin: "-#{size.height / 2}px -#{size.width / 2}px"

  size: =>
    ratio = Math.max (@dimensions.height / ($(window).height() - @settings.padding)) , (@dimensions.width / ($(window).width()  - @settings.padding))
    width:  if ratio > 1.0 then Math.round(@dimensions.width  / ratio) else @dimensions.width
    height: if ratio > 1.0 then Math.round(@dimensions.height / ratio) else @dimensions.height

  keyup: (event) =>
    return if event.target.form?
    @close() if event.which is 27 # esc
    @prev() if event.which is 37 # l-arrow
    @next() if event.which is 39 # r-arrow

  observe: (method = 'on') =>
    $(window)[method] "resize", @align
    $(document)[method] "keyup", @keyup
    @$overlay[method] "click", @close
    @$close[method] "click", @close
    @$next[method] "click", @next
    @$prev[method] "click", @prev

  hide: =>
    alpha = => @observe('off')
    omega = => @$el.remove()

    alpha()
    @$el.removeClass('fade')
    @$el.position()
    @$el.addClass('fade')
    Animation.execute(@$el, omega)

  show: =>
    omega = => @observe('on')
    alpha = => $(document.body).append @$el

    alpha()
    @$el.addClass('fade')
    @$el.position()
    @$el.removeClass('fade')
    Animation.execute(@$el, omega)

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
