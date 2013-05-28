$(document).on 'ready page:load', ->
  $('#about-page').timelinify
    debug:true
  $('.mediaelement').mediaelementplayer
    features: ['playpause','progress','current','duration','tracks','volume','fullscreen']
    alwaysShowControls: false