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

reducer = Redux.combineReducers preloadCache: preloadCache
window.store = Redux.createStore(reducer, {})

$(document).ready ->
  map = L.map('map').setView([25, 0], 3)
  map.addLayer(new L.Google('HYBRID'))
  window.player = null
  L.geoJson GEO_JSON,
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


GEO_JSON = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    4.8998388889,
                    52.3721944444
                ]
            },
            "properties": {
                "name": "MVI_2358",
                "description": "<i>June 11, 2013 &nbsp;&nbsp; 12:31:46 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    4.8984444444,
                    52.3738694444
                ]
            },
            "properties": {
                "name": "MVI_2360",
                "description": "<i>June 11, 2013 &nbsp;&nbsp; 12:41:35 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.8531166667,
                    1.2883388889
                ]
            },
            "properties": {
                "name": "MVI_2383",
                "description": "<i>June 13, 2013 &nbsp;&nbsp; 2:59:12 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.8584583333,
                    1.2827194444
                ]
            },
            "properties": {
                "name": "MVI_2441",
                "description": "<i>June 13, 2013 &nbsp;&nbsp; 10:26:20 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.8584583333,
                    1.2827194444
                ]
            },
            "properties": {
                "name": "MVI_2442",
                "description": "<i>June 13, 2013 &nbsp;&nbsp; 10:27:02 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.8584583333,
                    1.2827194444
                ]
            },
            "properties": {
                "name": "MVI_2459",
                "description": "<i>June 13, 2013 &nbsp;&nbsp; 10:47:41 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.8584583333,
                    1.2827194444
                ]
            },
            "properties": {
                "name": "MVI_2461",
                "description": "<i>June 13, 2013 &nbsp;&nbsp; 10:48:47 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8878027778,
                    20.6406305556
                ]
            },
            "properties": {
                "name": "MVI_2645",
                "description": "<i>June 21, 2013 &nbsp;&nbsp; 4:51:29 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    108.0000888889,
                    16.0430305556
                ]
            },
            "properties": {
                "name": "MVI_3760",
                "description": "<i>June 26, 2013 &nbsp;&nbsp; 3:07:36 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    107.5773888889,
                    16.4700055556
                ]
            },
            "properties": {
                "name": "MVI_3924",
                "description": "<i>June 27, 2013 &nbsp;&nbsp; 1:55:40 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    107.5771861111,
                    16.4698305556
                ]
            },
            "properties": {
                "name": "MVI_3925",
                "description": "<i>June 27, 2013 &nbsp;&nbsp; 2:00:01 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    107.5899972222,
                    16.3986555556
                ]
            },
            "properties": {
                "name": "MVI_3930",
                "description": "<i>June 27, 2013 &nbsp;&nbsp; 2:42:44 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    107.5903194444,
                    16.398775
                ]
            },
            "properties": {
                "name": "MVI_3932",
                "description": "<i>June 27, 2013 &nbsp;&nbsp; 2:44:19 AM</i>"
            }
        },
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
                "name": "MVI_4013",
                "description": "<i>June 28, 2013 &nbsp;&nbsp; 6:09:10 AM</i>"
            }
        },
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
                "name": "MVI_4014",
                "description": "<i>June 28, 2013 &nbsp;&nbsp; 6:11:05 AM</i>"
            }
        },
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
                "name": "MVI_4015",
                "description": "<i>June 28, 2013 &nbsp;&nbsp; 6:12:02 AM</i>"
            }
        },
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
                "name": "MVI_4016",
                "description": "<i>June 28, 2013 &nbsp;&nbsp; 6:16:30 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    108.3276444444,
                    15.8761777778
                ]
            },
            "properties": {
                "name": "MVI_4061",
                "description": "<i>June 29, 2013 &nbsp;&nbsp; 11:42:43 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    108.2832416667,
                    15.9766333333
                ]
            },
            "properties": {
                "name": "MVI_4072",
                "description": "<i>June 30, 2013 &nbsp;&nbsp; 10:05:26 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    108.2835,
                    15.9766666667
                ]
            },
            "properties": {
                "name": "MVI_4073",
                "description": "<i>June 30, 2013 &nbsp;&nbsp; 10:06:48 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.6191388889,
                    51.798775
                ]
            },
            "properties": {
                "name": "MVI_5365",
                "description": "<i>August 3, 2013 &nbsp;&nbsp; 6:55:45 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.6191194444,
                    51.7986805556
                ]
            },
            "properties": {
                "name": "MVI_5404",
                "description": "<i>August 3, 2013 &nbsp;&nbsp; 7:38:08 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.6661555556,
                    51.6730361111
                ]
            },
            "properties": {
                "name": "MVI_5557",
                "description": "<i>August 3, 2013 &nbsp;&nbsp; 11:33:21 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.6630083333,
                    51.6662222222
                ]
            },
            "properties": {
                "name": "MVI_6244",
                "description": "<i>August 3, 2013 &nbsp;&nbsp; 2:58:46 PM</i>"
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
                "name": "MVI_6355",
                "description": "<i>August 28, 2013 &nbsp;&nbsp; 1:07:17 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -90.1919861111,
                    38.6263
                ]
            },
            "properties": {
                "name": "MVI_8140",
                "description": "<i>November 16, 2013 &nbsp;&nbsp; 2:53:17 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -90.1907916667,
                    38.6259444444
                ]
            },
            "properties": {
                "name": "MVI_8158",
                "description": "<i>November 16, 2013 &nbsp;&nbsp; 2:58:38 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -74.432925,
                    39.3550361111
                ]
            },
            "properties": {
                "name": "MVI_9235",
                "description": "<i>December 26, 2013 &nbsp;&nbsp; 1:51:44 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -74.4262111111,
                    39.3566083333
                ]
            },
            "properties": {
                "name": "MVI_9244",
                "description": "<i>December 26, 2013 &nbsp;&nbsp; 1:59:11 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -74.4212027778,
                    39.3580138889
                ]
            },
            "properties": {
                "name": "MVI_9250",
                "description": "<i>December 26, 2013 &nbsp;&nbsp; 2:14:36 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -75.1803111111,
                    39.965125
                ]
            },
            "properties": {
                "name": "MVI_9284",
                "description": "<i>December 26, 2013 &nbsp;&nbsp; 6:20:21 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -79.9301111111,
                    32.7694333333
                ]
            },
            "properties": {
                "name": "MVI_0539",
                "description": "<i>December 30, 2013 &nbsp;&nbsp; 1:56:09 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -79.9080916667,
                    32.7887388889
                ]
            },
            "properties": {
                "name": "MVI_0601",
                "description": "<i>December 30, 2013 &nbsp;&nbsp; 5:04:57 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -79.9085527778,
                    32.790275
                ]
            },
            "properties": {
                "name": "MVI_0609",
                "description": "<i>December 30, 2013 &nbsp;&nbsp; 5:24:22 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -79.9085722222,
                    32.7898805556
                ]
            },
            "properties": {
                "name": "MVI_0610",
                "description": "<i>December 30, 2013 &nbsp;&nbsp; 5:24:56 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -79.9085944444,
                    32.7911361111
                ]
            },
            "properties": {
                "name": "MVI_0627",
                "description": "<i>December 30, 2013 &nbsp;&nbsp; 5:33:37 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -85.3065,
                    35.0372138889
                ]
            },
            "properties": {
                "name": "MVI_0815",
                "description": "<i>January 4, 2014 &nbsp;&nbsp; 7:11:53 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.022075,
                    46.4108027778
                ]
            },
            "properties": {
                "name": "MVI_1934",
                "description": "<i>February 9, 2014 &nbsp;&nbsp; 4:25:08 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.0210555556,
                    46.4109777778
                ]
            },
            "properties": {
                "name": "MVI_1961",
                "description": "<i>February 9, 2014 &nbsp;&nbsp; 5:19:02 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    10.0211916667,
                    46.4110027778
                ]
            },
            "properties": {
                "name": "MVI_1996",
                "description": "<i>February 9, 2014 &nbsp;&nbsp; 5:33:52 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    9.9821138889,
                    46.4415611111
                ]
            },
            "properties": {
                "name": "MVI_2175",
                "description": "<i>February 9, 2014 &nbsp;&nbsp; 9:16:29 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    9.982125,
                    46.4415444444
                ]
            },
            "properties": {
                "name": "MVI_2267",
                "description": "<i>February 9, 2014 &nbsp;&nbsp; 9:47:40 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    8.5434694444,
                    47.3701166667
                ]
            },
            "properties": {
                "name": "MVI_2326",
                "description": "<i>February 10, 2014 &nbsp;&nbsp; 6:26:06 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    11.5758361111,
                    48.1370638889
                ]
            },
            "properties": {
                "name": "MVI_2381",
                "description": "<i>February 11, 2014 &nbsp;&nbsp; 7:16:26 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    11.5758361111,
                    48.1370638889
                ]
            },
            "properties": {
                "name": "MVI_2383",
                "description": "<i>February 11, 2014 &nbsp;&nbsp; 7:17:34 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -80.1291416667,
                    25.7849388889
                ]
            },
            "properties": {
                "name": "2014-03-11 18.26",
                "description": "<i>March 11, 2014 &nbsp;&nbsp; 10:26:16 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -80.129475,
                    25.7837805556
                ]
            },
            "properties": {
                "name": "Video",
                "description": "<i>March 19, 2014 &nbsp;&nbsp; 2:37:15 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -73.9736138889,
                    40.768325
                ]
            },
            "properties": {
                "name": "MVI_2599",
                "description": "<i>May 23, 2014 &nbsp;&nbsp; 4:40:34 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -73.9736138889,
                    40.768325
                ]
            },
            "properties": {
                "name": "MVI_2602",
                "description": "<i>May 23, 2014 &nbsp;&nbsp; 4:41:28 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -74.0172916667,
                    40.6957805556
                ]
            },
            "properties": {
                "name": "MVI_2677",
                "description": "<i>May 24, 2014 &nbsp;&nbsp; 1:36:29 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -74.0102638889,
                    40.7068555556
                ]
            },
            "properties": {
                "name": "MVI_2693",
                "description": "<i>May 24, 2014 &nbsp;&nbsp; 2:34:55 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -73.9795611111,
                    40.7589027778
                ]
            },
            "properties": {
                "name": "MVI_2805",
                "description": "<i>May 25, 2014 &nbsp;&nbsp; 6:03:20 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -73.995775,
                    40.7008388889
                ]
            },
            "properties": {
                "name": "MVI_2840",
                "description": "<i>May 25, 2014 &nbsp;&nbsp; 8:31:51 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -77.0070527778,
                    38.8898166667
                ]
            },
            "properties": {
                "name": "MVI_2887",
                "description": "<i>May 27, 2014 &nbsp;&nbsp; 11:51:26 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -77.0365305556,
                    38.8985833333
                ]
            },
            "properties": {
                "name": "MVI_2918",
                "description": "<i>May 27, 2014 &nbsp;&nbsp; 6:59:57 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -77.0365305556,
                    38.8985833333
                ]
            },
            "properties": {
                "name": "MVI_2919",
                "description": "<i>May 27, 2014 &nbsp;&nbsp; 7:00:07 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -77.0483277778,
                    38.889225
                ]
            },
            "properties": {
                "name": "MVI_2952",
                "description": "<i>May 28, 2014 &nbsp;&nbsp; 12:58:29 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -77.0483277778,
                    38.889225
                ]
            },
            "properties": {
                "name": "MVI_2953",
                "description": "<i>May 28, 2014 &nbsp;&nbsp; 12:58:41 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -85.6870416667,
                    10.5684666667
                ]
            },
            "properties": {
                "name": "MVI_3013",
                "description": "<i>June 3, 2014 &nbsp;&nbsp; 12:28:18 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -85.6967777778,
                    10.5728916667
                ]
            },
            "properties": {
                "name": "MVI_3046",
                "description": "<i>June 3, 2014 &nbsp;&nbsp; 1:33:38 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -64.7675916667,
                    18.353875
                ]
            },
            "properties": {
                "name": "GOPR0497",
                "description": "<i>January 12, 2015 &nbsp;&nbsp; 12:26:55 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -64.7675916667,
                    18.353875
                ]
            },
            "properties": {
                "name": "GOPR0503",
                "description": "<i>January 12, 2015 &nbsp;&nbsp; 1:25:52 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -64.9565055556,
                    18.3183305556
                ]
            },
            "properties": {
                "name": "GOPR0657",
                "description": "<i>January 14, 2015 &nbsp;&nbsp; 10:16:15 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.859,
                    1.2838472222
                ]
            },
            "properties": {
                "name": "GOPR0776",
                "description": "<i>February 8, 2015 &nbsp;&nbsp; 2:31:37 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8202333333,
                    21.0842111111
                ]
            },
            "properties": {
                "name": "MVI_7938",
                "description": "<i>February 16, 2015 &nbsp;&nbsp; 5:57:27 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8202333333,
                    21.0842111111
                ]
            },
            "properties": {
                "name": "MVI_7979",
                "description": "<i>February 16, 2015 &nbsp;&nbsp; 6:20:17 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8650027778,
                    20.2745388889
                ]
            },
            "properties": {
                "name": "MVI_8160",
                "description": "<i>February 20, 2015 &nbsp;&nbsp; 1:55:21 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8994277778,
                    20.2620083333
                ]
            },
            "properties": {
                "name": "GOPR0794",
                "description": "<i>February 20, 2015 &nbsp;&nbsp; 3:33:34 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    106.7240027778,
                    22.8547555556
                ]
            },
            "properties": {
                "name": "MVI_8371",
                "description": "<i>February 22, 2015 &nbsp;&nbsp; 7:37:28 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    106.7235555556,
                    22.8543805556
                ]
            },
            "properties": {
                "name": "GOPR0813",
                "description": "<i>February 22, 2015 &nbsp;&nbsp; 5:49:29 PM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    106.7063555556,
                    22.8441972222
                ]
            },
            "properties": {
                "name": "MVI_8853",
                "description": "<i>February 23, 2015 &nbsp;&nbsp; 12:39:21 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    101.7145722222,
                    3.1554805556
                ]
            },
            "properties": {
                "name": "MVI_8978",
                "description": "<i>March 6, 2015 &nbsp;&nbsp; 5:40:01 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    101.7146944444,
                    3.1554805556
                ]
            },
            "properties": {
                "name": "MVI_8979",
                "description": "<i>March 6, 2015 &nbsp;&nbsp; 5:40:44 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    101.6924833333,
                    3.1417694444
                ]
            },
            "properties": {
                "name": "MVI_8985",
                "description": "<i>March 7, 2015 &nbsp;&nbsp; 12:21:52 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    101.6934138889,
                    3.1485138889
                ]
            },
            "properties": {
                "name": "MVI_8988",
                "description": "<i>March 7, 2015 &nbsp;&nbsp; 2:08:25 AM</i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    101.7113277778,
                    3.1569694444
                ]
            },
            "properties": {
                "name": "MVI_9032",
                "description": "<i>March 7, 2015 &nbsp;&nbsp; 7:32:21 AM</i>"
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
                "name": "1080p",
                "description": "<i>August 17, 2015 &nbsp;&nbsp; 7:26:41 PM</i><br/>Altitude: 393.7 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -71.5698194444,
                    42.4923833333
                ]
            },
            "properties": {
                "name": "IMG_1054",
                "description": "<i>October 4, 2015 &nbsp;&nbsp; 8:06:36 PM</i><br/>Altitude: 538.6 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.7396222222,
                    44.35265
                ]
            },
            "properties": {
                "name": "IMG_1074",
                "description": "<i>October 10, 2015 &nbsp;&nbsp; 9:12:09 PM</i><br/>Altitude: 602.4 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.8155611111,
                    44.5420472222
                ]
            },
            "properties": {
                "name": "IMG_1089",
                "description": "<i>October 11, 2015 &nbsp;&nbsp; 6:37:08 PM</i><br/>Altitude: 4,266.5 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.8155611111,
                    44.5420472222
                ]
            },
            "properties": {
                "name": "IMG_1094",
                "description": "<i>October 11, 2015 &nbsp;&nbsp; 7:46:04 PM</i><br/>Altitude: 4,266.5 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.8155611111,
                    44.5420472222
                ]
            },
            "properties": {
                "name": "IMG_1096",
                "description": "<i>October 11, 2015 &nbsp;&nbsp; 7:47:15 PM</i><br/>Altitude: 4,266.5 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.8163472222,
                    44.5420416667
                ]
            },
            "properties": {
                "name": "IMG_1097",
                "description": "<i>October 11, 2015 &nbsp;&nbsp; 7:50:47 PM</i><br/>Altitude: 4,200.7 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.8155611111,
                    44.5420472222
                ]
            },
            "properties": {
                "name": "IMG_1098",
                "description": "<i>October 11, 2015 &nbsp;&nbsp; 7:51:11 PM</i><br/>Altitude: 4,266.5 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.8155611111,
                    44.5420472222
                ]
            },
            "properties": {
                "name": "IMG_1125",
                "description": "<i>October 11, 2015 &nbsp;&nbsp; 9:09:00 PM</i><br/>Altitude: 4,266.5 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -71.1298972222,
                    42.3595555556
                ]
            },
            "properties": {
                "name": "IMG_1200",
                "description": "<i>November 1, 2015 &nbsp;&nbsp; 5:24:30 AM</i><br/>Altitude: 13.9 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -77.03275,
                    39.4051888889
                ]
            },
            "properties": {
                "name": "IMG_1210",
                "description": "<i>November 27, 2015 &nbsp;&nbsp; 9:14:17 PM</i><br/>Altitude: 705.9 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    23.7234888889,
                    37.9708694444
                ]
            },
            "properties": {
                "name": "IMG_1226",
                "description": "<i>December 20, 2015 &nbsp;&nbsp; 11:59:02 AM</i><br/>Altitude: 348.2 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    23.7202222222,
                    37.9712972222
                ]
            },
            "properties": {
                "name": "IMG_1228",
                "description": "<i>December 20, 2015 &nbsp;&nbsp; 12:31:13 PM</i><br/>Altitude: 330.2 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    23.7335472222,
                    37.969075
                ]
            },
            "properties": {
                "name": "MVI_9264",
                "description": "<i>December 21, 2015 &nbsp;&nbsp; 7:27:26 AM</i><br/>Altitude: 259.2 ft"
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
                "name": "MVI_9438",
                "description": "<i>December 22, 2015 &nbsp;&nbsp; 5:42:09 AM</i><br/>Altitude: 277.8 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    22.5006333333,
                    38.4824472222
                ]
            },
            "properties": {
                "name": "MVI_9518",
                "description": "<i>December 23, 2015 &nbsp;&nbsp; 6:49:56 AM</i><br/>Altitude: 1,955.4 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    22.5006333333,
                    38.4824472222
                ]
            },
            "properties": {
                "name": "MVI_9544",
                "description": "<i>December 23, 2015 &nbsp;&nbsp; 7:37:56 AM</i><br/>Altitude: 1,955.4 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    22.5078138889,
                    38.4801305556
                ]
            },
            "properties": {
                "name": "MVI_9563",
                "description": "<i>December 23, 2015 &nbsp;&nbsp; 8:42:16 AM</i><br/>Altitude: 1,592.9 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    23.1304555556,
                    37.4234416667
                ]
            },
            "properties": {
                "name": "MVI_0521",
                "description": "<i>December 25, 2015 &nbsp;&nbsp; 10:00:44 AM</i><br/>Altitude: 20.2 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    23.1679861111,
                    37.4696833333
                ]
            },
            "properties": {
                "name": "MVI_0561",
                "description": "<i>December 25, 2015 &nbsp;&nbsp; 11:28:58 AM</i><br/>Altitude: 569.4 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    22.8738277778,
                    37.5270027778
                ]
            },
            "properties": {
                "name": "MVI_0712",
                "description": "<i>December 26, 2015 &nbsp;&nbsp; 10:45:24 AM</i><br/>Altitude: 60.1 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    22.8738277778,
                    37.5270027778
                ]
            },
            "properties": {
                "name": "MVI_0713",
                "description": "<i>December 26, 2015 &nbsp;&nbsp; 10:45:58 AM</i><br/>Altitude: 60.1 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    11.7639861111,
                    47.1932611111
                ]
            },
            "properties": {
                "name": "IMG_1257",
                "description": "<i>January 2, 2016 &nbsp;&nbsp; 10:55:01 AM</i><br/>Altitude: 8,035.7 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    9.9613861111,
                    53.5480138889
                ]
            },
            "properties": {
                "name": "1050412_10201417503180218_764006266_n",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    18.421,
                    -33.9061
                ]
            },
            "properties": {
                "name": "IMG_0443",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    18.4517777778,
                    -34.19795
                ]
            },
            "properties": {
                "name": "IMG_0572",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    18.4516805556,
                    -34.1979555556
                ]
            },
            "properties": {
                "name": "IMG_0580",
                "description": "<i> &nbsp;&nbsp; </i>"
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
                "name": "IMG_0732",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 67  ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -8.4663111111,
                    37.093225
                ]
            },
            "properties": {
                "name": "IMG_0736",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 69.3 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -8.4649916667,
                    37.0924416667
                ]
            },
            "properties": {
                "name": "IMG_0743",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 30.1 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -8.6684305556,
                    37.0801583333
                ]
            },
            "properties": {
                "name": "IMG_0756",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 7.9 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -8.8847305556,
                    37.962225
                ]
            },
            "properties": {
                "name": "IMG_0784",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 30.5 ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -9.1335888889,
                    38.7136166667
                ]
            },
            "properties": {
                "name": "IMG_0796",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 322  ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -9.2055111111,
                    38.6936166667
                ]
            },
            "properties": {
                "name": "IMG_0808",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 14.1 ft"
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
                "name": "IMG_0832",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 3,646  ft"
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
                "name": "IMG_0845",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 3,646  ft"
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
                "name": "IMG_0847",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 3,646  ft"
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
                "name": "IMG_0848",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 3,646  ft"
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
                "name": "IMG_0855",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 3,646  ft"
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
                "name": "IMG_0856",
                "description": "<i> &nbsp;&nbsp; </i><br/>Altitude: 3,646  ft"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7104611111,
                    40.4154388889
                ]
            },
            "properties": {
                "name": "MVI_0828",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7104611111,
                    40.4154388889
                ]
            },
            "properties": {
                "name": "MVI_0830",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7104611111,
                    40.4154388889
                ]
            },
            "properties": {
                "name": "MVI_0831",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7104611111,
                    40.4154388889
                ]
            },
            "properties": {
                "name": "MVI_0832",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7104611111,
                    40.4154388889
                ]
            },
            "properties": {
                "name": "MVI_0833",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7144527778,
                    40.4163555556
                ]
            },
            "properties": {
                "name": "MVI_0841",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.7167472222,
                    40.4227916667
                ]
            },
            "properties": {
                "name": "MVI_0846",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.5987277778,
                    37.1755972222
                ]
            },
            "properties": {
                "name": "MVI_0905",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.5987277778,
                    37.1755972222
                ]
            },
            "properties": {
                "name": "MVI_0906",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.6010388889,
                    37.177375
                ]
            },
            "properties": {
                "name": "MVI_0907",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.5988333333,
                    37.1809638889
                ]
            },
            "properties": {
                "name": "MVI_0911",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.5901027778,
                    37.17585
                ]
            },
            "properties": {
                "name": "MVI_0940",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.5901027778,
                    37.17585
                ]
            },
            "properties": {
                "name": "MVI_0941",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.58715,
                    37.1752861111
                ]
            },
            "properties": {
                "name": "MVI_0945",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.587,
                    37.1753166667
                ]
            },
            "properties": {
                "name": "MVI_0947",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -3.5848666667,
                    37.1762333333
                ]
            },
            "properties": {
                "name": "MVI_0989",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -5.9874888889,
                    37.3767861111
                ]
            },
            "properties": {
                "name": "MVI_1016",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -5.9874888889,
                    37.3767861111
                ]
            },
            "properties": {
                "name": "MVI_1029",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -5.9874888889,
                    37.3767861111
                ]
            },
            "properties": {
                "name": "MVI_1030",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -5.9934388889,
                    37.3850944444
                ]
            },
            "properties": {
                "name": "MVI_1038",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -5.9934388889,
                    37.3850944444
                ]
            },
            "properties": {
                "name": "MVI_1039",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -5.9874777778,
                    37.3797972222
                ]
            },
            "properties": {
                "name": "MVI_1044",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    2.6703916667,
                    39.5593222222
                ]
            },
            "properties": {
                "name": "MVI_1060",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    9.1901777778,
                    45.4638694444
                ]
            },
            "properties": {
                "name": "MVI_1087",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    9.1890611111,
                    45.4640944444
                ]
            },
            "properties": {
                "name": "MVI_1088",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    12.3388194444,
                    45.4365083333
                ]
            },
            "properties": {
                "name": "MVI_1135",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    12.3388194444,
                    45.4365083333
                ]
            },
            "properties": {
                "name": "MVI_1136",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    12.3279277778,
                    45.4421861111
                ]
            },
            "properties": {
                "name": "MVI_1230",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.85285,
                    21.0307444444
                ]
            },
            "properties": {
                "name": "MVI_4194",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8535333333,
                    21.0285638889
                ]
            },
            "properties": {
                "name": "MVI_4195",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8878277778,
                    20.6403166667
                ]
            },
            "properties": {
                "name": "MVI_4285",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8878277778,
                    20.6403166667
                ]
            },
            "properties": {
                "name": "MVI_4286",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8521583333,
                    21.0347527778
                ]
            },
            "properties": {
                "name": "MVI_4287",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.85195,
                    21.0319138889
                ]
            },
            "properties": {
                "name": "MVI_4288",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    106.3236194444,
                    20.8395416667
                ]
            },
            "properties": {
                "name": "MVI_4343",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8194305556,
                    21.0684194444
                ]
            },
            "properties": {
                "name": "MVI_4413",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    105.8194305556,
                    21.0684194444
                ]
            },
            "properties": {
                "name": "MVI_4416",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.8343861111,
                    22.3299638889
                ]
            },
            "properties": {
                "name": "MVI_4488",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.7791805556,
                    22.3635638889
                ]
            },
            "properties": {
                "name": "MVI_4572",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.7791805556,
                    22.3635638889
                ]
            },
            "properties": {
                "name": "MVI_4574",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    103.7791805556,
                    22.3635638889
                ]
            },
            "properties": {
                "name": "MVI_4575",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4923222222,
                    13.7517277778
                ]
            },
            "properties": {
                "name": "MVI_4826",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4926833333,
                    13.7517888889
                ]
            },
            "properties": {
                "name": "MVI_4864",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4926833333,
                    13.7517888889
                ]
            },
            "properties": {
                "name": "MVI_4867",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4926833333,
                    13.7517888889
                ]
            },
            "properties": {
                "name": "MVI_4868",
                "description": "<i> &nbsp;&nbsp; </i>"
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
                "name": "MVI_4870",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.493,
                    13.7516638889
                ]
            },
            "properties": {
                "name": "MVI_4888",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4912444444,
                    13.7504638889
                ]
            },
            "properties": {
                "name": "MVI_4909",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4912444444,
                    13.7504638889
                ]
            },
            "properties": {
                "name": "MVI_4910",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    100.4926555556,
                    13.7468111111
                ]
            },
            "properties": {
                "name": "MVI_4943",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -72.9114777778,
                    43.1058333333
                ]
            },
            "properties": {
                "name": "VID_20131220_153525",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -81.0926166667,
                    32.0756472222
                ]
            },
            "properties": {
                "name": "VID_20131229_152935",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -84.4004972222,
                    33.7574361111
                ]
            },
            "properties": {
                "name": "VID_20131231_215243",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -86.7432305556,
                    36.1985916667
                ]
            },
            "properties": {
                "name": "VID_20140106_101257",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -118.5000027778,
                    34.0075277778
                ]
            },
            "properties": {
                "name": "VID_20140124_172730",
                "description": "<i> &nbsp;&nbsp; </i>"
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
                "name": "VID_20140125_103323",
                "description": "<i> &nbsp;&nbsp; </i>"
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
                "name": "VID_20140208_111034",
                "description": "<i> &nbsp;&nbsp; </i>"
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
                "name": "VID_20140221_175603",
                "description": "<i> &nbsp;&nbsp; </i>"
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
                "name": "VID_20141001_214245284",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    11.5486583333,
                    48.1327805556
                ]
            },
            "properties": {
                "name": "VID_20141001_220631200",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -122.4481944444,
                    37.802875
                ]
            },
            "properties": {
                "name": "VID_20141118_142406531",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -122.4631305556,
                    37.8045888889
                ]
            },
            "properties": {
                "name": "VID_20141118_145224962",
                "description": "<i> &nbsp;&nbsp; </i>"
            }
        }
    ]
}
