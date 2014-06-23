###
@TODO

@namespace Atoms.Molecule
@class LeafletFullScreen

@author Julen Garcia Leunda @hicom150
###
"use strict"

class Atoms.Organism.Leaflet extends Atoms.Organism.Section

  @extends  : true

  @template : """
    <section {{#if.id}}id="{{id}}"{{/if.id}}></section>
  """

  @available: ["Atom.Input", "Atom.Button", "Atom.Leaflet", "Molecule.Form"]

  @events   : ["menu"]

  @tile     : "http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png"

  @default  :
    style   : "menu form",
    children: [
      "Atom.Leaflet": id: "instance", tile: @tile, events: ["query"]
    ,
      "Atom.Button": icon: "navicon", style: "small"
    ,
      "Molecule.Form": events: ["submit"], children: [
        "Atom.Input": name: "address", placeholder: "Type a address", required: true
      ,
        "Atom.Button": icon: "search", text: "Search", style: "fluid accept"
      ]
    ]

  onFormSubmit: (event, form) ->
    event.preventDefault()
    @instance.query form.value().address
    false

  onLeafletQuery: (places) ->
    @instance.clean()
    if places.length > 0
      @instance.marker places[0].position
      @instance.center places[0].position, zoom = 16
    false

  onButtonTouch: (event) ->
    event.preventDefault()
    @bubble "menu", event
    false
