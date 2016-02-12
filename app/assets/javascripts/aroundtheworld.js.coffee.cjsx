# = require jquery
# = require jquery_ujs
# = require leaflet
# = require leaflet.google

internalState = {}
queueReducer = (state = { queue: [], preloadCache: {}, currentActive: -1 }, action) ->
  indexOf = (id) -> state.queue.indexOf(id)

  nextId = (id) ->
    state.queue[(indexOf(id) + 1) % state.queue.length]

  cacheVideo = (id) ->
    el = $("<div id='cachedVideo#{id}' class='youtubeplayer hidden'></div>")
    $('#cachedVideos').append(el)
    new YT.Player("cachedVideo#{id}", {
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
        onStateChange: (event) ->
          store.dispatch type: 'INITIAL_AUTO_PLAY_STARTED', id: id if event.data == 1
          store.dispatch type: 'PLAY_ENDED', id: id if event.data == 0
    })
  addToCache = (preloadCache, id) ->
    Object.assign {}, preloadCache, "#{id}": { ytPlayer: cacheVideo(id) }
  hideVideo = (id) ->
    $("#cachedVideo#{id}").addClass('hidden')
    state.preloadCache[id].ytPlayer.pauseVideo()
  showVideo = (id) ->
    state.preloadCache[id].ytPlayer.seekTo(0)
    state.preloadCache[id].ytPlayer.playVideo()
    $("#cachedVideo#{id}").removeClass('hidden')
    next = nextId(id)
    setTimeout (-> store.dispatch type: 'PRELOAD_VIDEO', id: next), 100

  switch action.type
    when 'PRELOAD_VIDEO'
      if state.preloadCache[action.id]
        state
      else
        id = action.id
        console.log 'addToCache'
        console.log id
        newState = Object.assign {}, state, preloadCache: addToCache(state.preloadCache, id)
        console.log newState
        newState
    when 'PLAY_VIDEO'
      if state.currentActive != -1 and state.currentActive != indexOf(action.id)
        hideVideo state.queue[state.currentActive]

      if state.currentActive == indexOf(action.id)
        state
      else
        newId = action.id
        showVideo(newId)

        setTimeout (-> store.dispatch type: 'PLAY_ENDED', id: newId), 3000

        Object.assign {}, state, currentActive: indexOf(newId)
    when 'INITIAL_AUTO_PLAY_STARTED'
      id = action.id
      state.preloadCache[id].ytPlayer.pauseVideo() unless state.currentActive == indexOf(id)
      state
    when 'PLAY_ENDED'
      hideVideo action.id

      newId = nextId(action.id)

      showVideo(newId)

      setTimeout (-> store.dispatch type: 'PLAY_ENDED', id: newId), 3000

      Object.assign {}, state, currentActive: indexOf(newId)
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

reducer = Redux.combineReducers queueReducer: queueReducer, properties: properties
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
  items: state.queueReducer.queue.map (id) -> state.properties[id]

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
      .on 'mouseover', (e) -> store.dispatch type: 'PRELOAD_VIDEO', id: feature.properties.id
      .on 'click', (e) -> store.dispatch type: 'PLAY_VIDEO', id: feature.properties.id
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
                    21.0113277778,
                    52.2510527778
                ]
            },
            "properties": {
                "id": "nf9pAraanoQ",
                "name": "Warsaw, Poland",
                "description": "https://youtu.be/nf9pAraanoQ;28-08-2013"
            }
        },
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
                "id": "UpY3g0iYsRk",
                "name": "Panathenic Statdium, Athens, Greece",
                "description": "https://youtu.be/UpY3g0iYsRk;22-12-2015"
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
                "id": "saLOxSw2L2Y",
                "name": "Gulfoss, Iceland",
                "description": "https://youtu.be/saLOxSw2L2Y;27-01-2016"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -8.4660166667,
                    37.0931277778
                ]
            },
            "properties": {
                "id": "wisVWS64ptU",
                "name": "Algar Seco",
                "description": "https://youtu.be/wisVWS64ptU;"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    6.1232277778,
                    46.0872694444
                ]
            },
            "properties": {
                "id": "x19Fn1SOOG8",
                "name": "Geneva, Switzerland",
                "description": "https://youtu.be/x19Fn1SOOG8;"
            }
        }
    ]
}
