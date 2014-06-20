###
@TODO

@namespace Atoms.Atom
@class Leaflet

@author Julen Garcia Leunda @hicom150
###
"use strict"

class Atoms.Atom.Leaflet extends Atoms.Class.Atom

  @template : """
    <div id=leaflet {{#if.style}}class="{{style}}"{{/if.style}}></div>"""

  @base     : "Leaflet"

  @events   : ["query"]

  _map      : null
  _markers  : []
  _query    : []
  _route    : null

  output: ->
    super
    exists = Atoms.$("[data-extension=leaflet]").length > 0
    if exists then do @__init else __loadScript @__init

  # Methods Instance
  center: (position, zoom_level = 8) ->
    latLng = L.latLng position.latitude, position.longitude
    @_map.setView latLng, zoom_level

  zoom: (level) ->
    @_map.setZoom level

  query: (value) ->
    if typeof value is "string"
      @_query = []
      __geocode(value).then (error, results) =>
        @_query = (__parseAddress result for result in results)
        @bubble "query", @_query
    true

  marker: (position, icon, animate = false) ->
    latLng = L.latLng position.latitude, position.longitude
    markerOptions = 
      icon : __markerIcon icon
    marker = new L.marker latLng, markerOptions
    @_map.addLayer marker
    @_markers.push marker
    true

  clean: ->
    @_map.removeLayer marker for marker in @_markers
    @_markers = []
    # @_route?.renderer.setMap null
    # @_route = null

  # Privates
  __init: =>
    setTimeout =>
      mapOptions = 
        center: [43.256963, -2.923441]
        zoom: 1
        zoomControl: false
      tileUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
      tileOptions = 
        attribution: 'Map data &copy;
          <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
      @_map = L.map 'leaflet', mapOptions
      L.tileLayer(tileUrl, tileOptions).addTo(@_map)
    , 1000

# ==============================================================================

__loadScript = (callback) ->
  window.google = maps: {}
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"
  script.setAttribute "data-extension", "leaflet"
  script.onload = -> callback.call @ if callback?
  document.body.appendChild script

do __loadScript

__markerIcon = (icon) ->
  if icon
    iconOptions = 
      iconUrl: icon.url
      #iconRetinaUrl: icon.retinaUrl
      iconSize: [icon.size_x, icon.size_y]
      iconAnchor: [icon.anchor_x, icon.anchor_y]
    L.icon iconOptions
  else
    new L.Icon.Default()

__queryPlace = (value) ->
  if value.latitude? and value.longitude?
    value = L.latLng value.latitude, value.longitude
  else
    value = null
  value

__parseAddress = (address) ->
  address : address.display_name
  type    : address.type
  position:
    latitude  : address.lat
    longitude : address.lon

# __parseRouteSteps = (instructions) ->
#   steps = []
#   for step in instructions.steps
#     steps.push
#       distance    : step.distance.text,
#       duration    : step.duration.text,
#       instructions: step.instructions
#   steps

__geocode = (value) ->
  promise = new Hope.Promise()

  $$.ajax
    url     : "http://nominatim.openstreetmap.org/search"
    data    : {q:value, format:'json'}
    success : (response) =>
      promise.done null, response
    error   : (response, error) =>
      console.error error
      promise.done error, null
  promise

