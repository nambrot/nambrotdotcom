$(document).on 'ready page:load', ->
  if $('#about-page').hasClass('timelinified')
    return
  $('#about-page').timelinify
    debug:true
  $('#about-page').find("img[data-gallery-decorate=true]").decorate_gallery()
  $('#about-page').addClass('timelinified')