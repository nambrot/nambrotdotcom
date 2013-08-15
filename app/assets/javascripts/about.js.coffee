$(document).on 'ready page:load', ->
  if $('#about-page').hasClass('timelinified')
    return
  $('#about-page').timelinify
    debug:true
    
  # give the page sometime to load
  setTimeout (->
      $('#about-page').find("img[data-gallery-decorate=true]").decorate_gallery()
    ),5000 
  
  $('#about-page').addClass('timelinified')