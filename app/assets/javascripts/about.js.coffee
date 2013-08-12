$(document).on 'ready page:load', ->
  if $('#about-page').hasClass('timelinified')
    return
  $('#about-page').timelinify
    debug:true
  $('#about-page').addClass('timelinified')