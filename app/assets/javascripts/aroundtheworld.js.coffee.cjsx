# = require jquery
# = require jquery_ujs
# = require leaflet
# = require leaflet.google

internalState = {}
queueReducer = (state = { queue: [], preloadCache: {}, currentActive: -1, nextPlayTimeout: null, playerState: 'stop' }, action) ->
  indexOf = (id) -> state.queue.indexOf(id)

  nextId = (id) ->
    state.queue[(indexOf(id) + 1) % state.queue.length]

  cacheVideo = (id) ->
    el = $("<div id='cachedVideo#{id}' class='youtubeplayer hidden'></div>")
    $('#cachedVideos').append(el)
    new YT.Player("cachedVideo#{id}", {
      width: 900,
      height: 400,
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
          store.dispatch type: 'PAUSE_VIDEO', id: id if event.data == 2
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
        newState = Object.assign {}, state, preloadCache: addToCache(state.preloadCache, id)
        newState
    when 'PLAY_VIDEO'
      clearTimeout(state.nextPlayTimeout)
      if state.currentActive != -1 and state.currentActive != indexOf(action.id)
        hideVideo state.queue[state.currentActive]

      if state.currentActive == indexOf(action.id)
        state
      else
        newId = action.id
        showVideo(newId)

        timeout = setTimeout (-> store.dispatch type: 'PLAY_ENDED', id: newId), 3000

        Object.assign {}, state, currentActive: indexOf(newId), nextPlayTimeout: timeout, playerState: 'play'
    when 'INITIAL_AUTO_PLAY_STARTED'
      id = action.id
      if state.currentActive == indexOf(id)
        newState = Object.assign {}, state, playerState: 'play'
        unless state.nextPlayTimeout
          newState.nextPlayTimeout = setTimeout (-> store.dispatch type: 'PLAY_ENDED', id: id), 3000
        newState
      else
        state.preloadCache[id].ytPlayer.pauseVideo()
        state
    when 'PLAY_ENDED'
      clearTimeout(state.nextPlayTimeout)
      hideVideo action.id
      newId = nextId(action.id)
      showVideo(newId)
      timeout = setTimeout (-> store.dispatch type: 'PLAY_ENDED', id: newId), 3000
      Object.assign {}, state, currentActive: indexOf(newId), nextPlayTimeout: timeout, playerState: 'play'
    when 'PAUSE_VIDEO'
      if state.currentActive == indexOf(action.id)
        clearTimeout state.nextPlayTimeout
        Object.assign {}, state, nextPlayTimeout: null, playerState: 'pause'
      else
        state
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
    <div className="PlayListItem #{if @props.item.isActive then @props.item.playerState else ''}">
      <span className='title'>{ @props.item.name }</span>
    </div>

PlayList = React.createClass
  getInitialState: ->
    isHover: false
  onMouseEnter: ->
    @setState isHover: true
  onMouseLeave: ->
    @setState isHover: false
  componentDidUpdate: (prevProps, prevState) ->
    if prevState.isHover and !@state.isHover
      @refs.container.scrollTop = 0
    if !prevState.isHover and @state.isHover
      setTimeout (=>
        @refs.container.scrollTop = _.max([this.props.currentActive - 3, 0]) * 38
        ), 250
  render: ->
    rootStyle = height: '90%'
    containerStyle = if @state.isHover
                       height: '90%'
                       overflow: 'scroll'
                     else
                       height: '37px'
                       overflow: 'hidden'

    marginTop = if @state.isHover then 0 else @props.currentActive * -37
    scrollContainerStyle =
      'margin-top': "#{marginTop}px"

    <div className='PlayListMenu' style=rootStyle onMouseEnter={@onMouseEnter} onMouseLeave={@onMouseLeave}>
      <h1>Around the world with Nam</h1>
      <div className='PlayListContainer' style=containerStyle ref='container'>
        <div className='PlayListScrollContainer' style=scrollContainerStyle>
          {
            @props.items.map (item) ->
              <PlayListItem item=item key=item.id />
          }
        </div>
      </div>
    </div>

mapStateToProps = (state) ->
  items: state.queueReducer.queue.map (id, idx) ->
    Object.assign(
      {},
      state.properties[id],
      isActive: state.queueReducer.currentActive == idx
      playerState: state.queueReducer.playerState
    )
  currentActive: state.queueReducer.currentActive

PlayListContainer = ReactRedux.connect(mapStateToProps)(PlayList)
Root = ->
  <ReactRedux.Provider store={store}><PlayListContainer /></ReactRedux.Provider>

$(document).ready ->
  window.map = L.map('map').setView([45, 0], 1)
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
                    108.2825416667,
                    15.9766861111
                ]
            },
            "properties": {
                "id": 'K7nFKJwbAwA',
                "name": "Danang, Thailand",
                "description": "https://youtu.be/K7nFKJwbAwA;28-06-2013"
            }
        },
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
                "id": 'nf9pAraanoQ',
                "name": "Warsaw, Poland",
                "description": "https://youtu.be/nf9pAraanoQ;28-08-2013"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -71.6893527778,
                    43.4777611111
                ]
            },
            "properties": {
                "id": 'KTIk7scgpKs',
                "name": "Franklin, New Hampshire",
                "description": "https://youtu.be/KTIk7scgpKs;17-08-2015"
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
                "id": 'UpY3g0iYsRk',
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
                "id": 'saLOxSw2L2Y',
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
                "id": 'wisVWS64ptU',
                "name": "Algar Seco, Portugal",
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
                "id": 'x19Fn1SOOG8',
                "name": "Geneva, Switzerland",
                "description": "https://youtu.be/x19Fn1SOOG8;"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4928527778,
                    13.7517638889
                ]
            },
            "properties": {
                "id": 'StfV6zyvMwU',
                "name": "Bangkok, Thailand",
                "description": "https://youtu.be/StfV6zyvMwU;"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -118.4938555556,
                    34.0084361111
                ]
            },
            "properties": {
                "id": '6U_Rfkqq0KI',
                "name": "Santa Monica, California",
                "description": "https://youtu.be/6U_Rfkqq0KI;"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.0196361111,
                    46.4088222222
                ]
            },
            "properties": {
                "id": 'uVO5fsAcOKk',
                "name": "Bernina, Switzerland",
                "description": "https://youtu.be/uVO5fsAcOKk;"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -71.3374666667,
                    42.3442305556
                ]
            },
            "properties": {
                "id": 'Sn8KJ7JRBOY',
                "name": "Wayland, Massachusetts",
                "description": "https://youtu.be/Sn8KJ7JRBOY;"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    11.5485,
                    48.1328583333
                ]
            },
            "properties": {
                "id": '2tlV9GSoBtw',
                "name": "Oktoberfest, Munich, Germany",
                "description": "https://youtu.be/2tlV9GSoBtw;"
            }
        }
    ]
}
