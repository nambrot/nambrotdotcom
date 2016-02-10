# = require jquery
# = require jquery_ujs
# = require leaflet
# = require leaflet.google

internalState = {}
preloadCache = (state = {}, action) ->
  switch action.type
    when 'PRELOAD_VIDEO'
      if state[action.id]
        state
      else
        id = action.id
        el = $("<div id='cachedVideo#{id}' class='youtubeplayer hidden'></div>")
        $('#cachedVideos').append(el)
        ytPlayer = new YT.Player("cachedVideo#{id}", {
          width: 400,
          height: 200,
          videoId: id,
          playerVars: {
            autohide: 1,
            autoplay: true,
            controls: 0,
            showinfo: 0
          },
          events:
            onReady: (event) -> event.target.playVideo()
            onStateChange: (event) -> store.dispatch type: 'INITIAL_AUTO_PLAY_STARTED', id: id if event.data == 1
        })
        Object.assign {}, state, "#{action.id}": { ytPlayer: ytPlayer }
    when 'PLAY_VIDEO'
      if state.active && state.active != action.id
        id = state.active
        $("#cachedVideo#{id}").addClass('hidden')
        state[id].ytPlayer.pause()

      if state.active == action.id
        state
      else
        newId = action.id
        state[newId].ytPlayer.seekTo(0)
        state[newId].ytPlayer.playVideo()
        $("#cachedVideo#{newId}").removeClass('hidden')

        Object.assign {}, state, active: newId
    when 'INITIAL_AUTO_PLAY_STARTED'
      id = action.id
      state[id].ytPlayer.pauseVideo() unless state.active == action.id
      state
    else
      state

playbackQueue = (state = { queue: [] }, action) ->
  switch action.type
    when 'INITIATE_QUEUE'
      GEO_JSON
    when 'ADD_TO_QUEUE'
      _.assign {}, state, queue: state.queue.concat([action.properties.id])
    when 'SHUFFLE_QUEUE'
      _.assign {}, state, queue: _.shuffle(state.queue)
    else
      state

properties = (state = {}, action) ->
  switch action.type
    when 'ADD_TO_QUEUE'
      _.assign {}, state, { "#{action.properties.id}": action.properties}
    else
      state

reducer = Redux.combineReducers preloadCache: preloadCache, playbackQueue: playbackQueue, properties: properties
window.store = Redux.createStore(reducer, {})

PlayListItem = React.createClass
  render: ->
    <div>
      <h3>{ @props.item.name }</h3>
    </div>

PlayList = React.createClass
  render: ->
    <div>
      <h1>Around the world with Nam</h1>
      {
        @props.items.map (item) ->
          <PlayListItem item=item />
      }
    </div>

mapStateToProps = (state) ->
  items: state.playbackQueue.queue.map (id) -> state.properties[id]

PlayListContainer = ReactRedux.connect(mapStateToProps)(PlayList)
Root = ->
  <ReactRedux.Provider store={store}><PlayListContainer /></ReactRedux.Provider>

$(document).ready ->
  map = L.map('map').setView([25, 0], 3)
  map.addLayer(new L.Google('HYBRID'))
  window.player = null
  React.render <Root />, document.getElementById('playlist')

  L.geoJson GEO_JSON,
    onEachFeature: (feature, layer) ->
      store.dispatch type: 'ADD_TO_QUEUE', properties: feature.properties
    pointToLayer: (feature, latlng) ->
      L.circleMarker latlng,
        radius: 8,
        fillColor: "#ff7800",
        color: "#000",
        weight: 1,
        opacity: 1,
        fillOpacity: 0.8
      .on 'mouseover', (e) -> store.dispatch type: 'PRELOAD_VIDEO', id: 'A8FiisqQpgw'
      .on 'click', (e) -> store.dispatch type: 'PLAY_VIDEO', id: 'A8FiisqQpgw'
  .addTo(map)

  store.dispatch type: 'SHUFFLE_QUEUE'

GEO_JSON = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    23.7410027778,
                    37.9685388889
                ]
            },
            "properties": {
                'id': 'UpY3g0iYsRk'
                "name": "Panathenic Statdium, Athens, Greece",
                "description": "22-12-2015"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -20.1212416667,
                    64.3272444444
                ]
            },
            "properties": {
                'id': 'saLOxSw2L2Y',
                "name": "Gulfoss, Iceland",
                "description": "27-01-2016"
            }
        }
    ]
}
