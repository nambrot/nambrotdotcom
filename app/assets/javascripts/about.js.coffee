$(document).on 'ready page:load', ->
  if $('#about-page').hasClass('timelinified')
    return
  console.log 'ready'
  console.log $('#about-page').hasClass('timelinified')
  $('#about-page').timelinify
    debug:true
  $('#about-page').addClass('timelinified')