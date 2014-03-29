# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# = require jquery
# = require jquery_ujs
# = require underscore
# = require backbone
# = require foundation/foundation
# = require foundation/foundation.dropdown
# = require leaflet
# = require leaflet.google

class App extends Backbone.Router
  initialize: ->
    @content_view = new ContentView
    @map_view = new MapView(this)
    
    @nav_view = new NavView
    $(document).foundation
      dropdown:
        opened: =>
          @content_view.collapse()
        closed: =>
          @content_view.uncollapse()
    $(document).on 'click.madagascar', '.madagascar-link', (evt) =>
      @navigate evt.currentTarget.pathname.split('/')[evt.currentTarget.pathname.split('/').length-1], trigger: true
      return false
  routes:
    "": "index"
    "*section": "go_to_section"
    
  # routes
  index: ->
    @content_view.go_to_id 'introduction', true
  go_to_section: (section) ->
    @content_view.go_to_id section, true


class NavView extends Backbone.View
  initialize: ->
    @$el = $("#dropdown-list")
    # $("#dropdown-list").on 'mouseover.madagascar', 'a', (evt) =>
      
  events: ->
    "mouseover a": "mouseover"
    "click a": "click"

  click: (evt) ->
    window.app.navigate evt.currentTarget.pathname.split('/')[evt.currentTarget.pathname.split('/').length-1], trigger: true
    Foundation.libs.dropdown.closeall()
    return false
  mouseover: (evt) ->
    id = evt.currentTarget.href.split('/')[evt.currentTarget.href.split('/').length-1]
    window.app.content_view.go_to_id id

class GeoLink

class MapView extends Backbone.View
  initialize: (app) ->
    @app = app
    @map = L.map('map').setView([-18.5, 52.8], 5)
    # L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        # attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    # }).addTo(@map);
    googleLayer = new L.Google('HYBRID')
    @map.addLayer(googleLayer)

    # fetch all geo_links to find in the sections
    for section in @app.content_view.sections
      section.geo_links = $(section).find('[data-madagascar-geolink-lat]')
      for link in section.geo_links
        marker = L.marker([$(link).data().madagascarGeolinkLat, $(link).data().madagascarGeolinkLng])
        marker.bindPopup $(link).find('.geolink-popup-content').html()
        $(link).data
          marker: marker
        marker.addTo(@map)    
  
  pan_to_link: (link) ->
    @map.setView $(link).data('marker').getLatLng(), $(link).data().madagascarGeolinkZoom, animate: true
    $(link).data('marker').openPopup()
  render: ->

class ContentView extends Backbone.View
  initialize: ->
    @el = document.getElementById('madagascar-content')
    @$el = $(@el)
    @current_section = 0
    @sections = @$el.find('section')
    @uncollapse()

    $(document).on 'click.madagascar', '#madagascar-content.collapse section', (evt) =>
      evt.preventDefault()
      Foundation.libs.dropdown.closeall()
      app.navigate evt.currentTarget.id, trigger: false
      @go_to_id evt.currentTarget.id, true
      return false
    

    # make it scroll
    @$el.on 'mousewheel', Foundation.utils.debounce ((evt) =>
      return unless @is_collapsed()
      if evt.originalEvent.wheelDeltaY > 5
        @go_to_index @current_section+1
      if evt.originalEvent.wheelDeltaY < -5
        @go_to_index @current_section-1
      return false;
      ), 20
  
  is_collapsed: ->
    return @$el.hasClass 'collapse'

  initialize_z_indecies: ->
    for section, index in @sections
        $(@sections[index]).css
          'display': 'block'
          'z-index': "#{30 - index}"
  events:
    'click [data-madagascar-geolink-lat]': 'triggerGeoLink'

  triggerGeoLink: (evt) ->
    app.map_view.pan_to_link evt.currentTarget
    return false
  toggle: ->
    @$el.toggleClass 'collapse'
  collapse: ->
    @$el.addClass 'collapse'

    # offset all the pages
    @set_collapsing_offsets()

  set_collapsing_offsets: ->
    i = 0
    while i < @sections.length
      transform_string = ''
      if i < @current_section
        # move them in the foreground
        transform_string = "rotateX(-30deg) translateZ(#{2000 - i * 100}px) translateY(#{400 - 60*i}px)"
      else
        transform_string = "rotateX(-30deg) translateZ(#{-300 - (i - @current_section) * 150}px) translateY(#{600 - 60*i}px)"
      $(@sections[i]).css
        '-webkit-transform': transform_string
        '-moz-transform': transform_string
        '-o-transform': transform_string
        '-ms-transform': transform_string
        'transform': transform_string
        'display': 'block'
        'z-index': "#{30 - i}"
      i++
  go_to_index: (index) ->
    return if index < 0 or index > @sections.length - 1
    @current_section = index
    @set_collapsing_offsets()
  go_to_id: (id, uncollapse = false) ->
    
    if uncollapse
      # check whether we are collpased or not
      if @$el.hasClass 'collapse'
        # we are collapsed, so just uncollapse
        @current_section = @sections.index @$el.find("section##{id}")
        @uncollapse()
      else
        # we want to collapse, move to the section, and then uncollapse if
        if @current_section != @sections.index @$el.find("section##{id}")
          @collapse()
          setTimeout (=>
              @current_section = @sections.index @$el.find("section##{id}")
              @set_collapsing_offsets()
              setTimeout (=>
                  @uncollapse()
                ), 300
            ),200
      
    else
      # just hover around
      @current_section = @sections.index @$el.find("section##{id}")
      @set_collapsing_offsets()
    
    
  uncollapse: ->
    @$el.removeClass 'collapse'
    @sections.css
      '-webkit-transform': 'none'
      '-moz-transform': 'none'
      '-o-transform': 'none'
      '-ms-transform': 'none'
      'transform': 'none'
    # set z-indecies
    for section, index in @sections
      console.log index, @current_section
      if index is @current_section
        $(@sections[index]).css
          'display': 'block'
          'z-index': "#{30 - index}"
      else
        $(@sections[index]).css
          'display': 'none'
          

$(document).ready ->
  window.app = new App
  Backbone.history.start({pushState: true, root: "/madagascar/", silent: false})



   