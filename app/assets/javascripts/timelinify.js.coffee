# Reference jQuery
$ = jQuery

class TimelineEntry
  cached_top_position: 0
  initialize_from_DOM_element: (element, settings) ->
    @element = element
    @$element = $(element)
    
    @settings = settings

    @categories = $.map @$element.find(@settings.timeline_entry_tag_selector).text().split(' '), (hashtag) ->
      hashtag.slice(1, hashtag.length - 1)
    @importance = parseInt(@$element.data('importance'))

    @hidden = @$element.hasClass 'hidden'
    this

  card_height: ->
    @$card_height ?= @$element.find(@settings.timeline_entry_card_selector).height()

  click: (evt) ->
    # flip it like its real good
    
    # add overlay
    @overlay = $('<div id="container-overlay"></div>')
    $('body').append @overlay
    @overlay.fadeIn 300

    # calculate position

    scrolltop = $('body').scrollTop()
    offset = @$element.offset()

    if $(window).height() > @$element.find('.about-timeline-entry-detail').height()/2
      # position the lightbox in the middle
      verticaloffset = $(window).height()/2 + scrolltop - offset.top - @$element.find('.about-timeline-entry-detail').height()/4
    else
      # lightbox is too big, position it at the viewport top
      verticaloffset = scrolltop - offset.top + 10
    
    horizontaloffset = $(window).width()/2 - offset.left - 225
   
    transform = "rotateY(180deg) translateX(300px) translateX(#{-horizontaloffset}px) translateY(#{verticaloffset}px)"
    @$element.addClass 'flip'
    @$element.find('.about-timeline-entry-detail').css
      display: 'block'
    @$element.css
      "webkitTransform": transform,
      "MozTransform": transform,
      "msTransform": transform,
      "OTransform": transform,
      "transform": transform
    

    setTimeout (=>
      $(document).on 'click.timelinify', (evt) =>
        if !$.contains(@element, evt.target)
          @flipback()
      @$element.find('.about-timeline-entry-detail').on 'click.timelinify', (evt) ->
        console.log 'click'
        evt.stopPropagation();
      
      ),100
  flipback: ->
    @overlay.fadeOut 300, =>
      @overlay.remove()
    $(document).off 'click.timelinify'
    @$element.find('.about-timeline-entry-detail').off 'click.timelinify'
    @$element.removeClass 'flip'
    $(@$element).css({
        "webkitTransform":"",
        "MozTransform":"",
        "msTransform":"",
        "OTransform":"",
        "transform":""
    })
    setTimeout (=>
      @$element.find('.about-timeline-entry-detail').css
        display: ''
      ), 300
  hide: ->
    @$element.css
          'top': '0px'
          'left': '-1000px'
          'z-index': '0'
          'opacity': '0'
  show: ->
    @$element.css
              'opacity': '1'
              'z-index': ''

class TimelineEntryManager
  column_mapping: [],
  entries_currently_displayed: [],
  initialize_from_DOM_elements: (entries, settings = {}) ->
    @entries_dom_elements = entries
    @timeline_entries = $.map entries, (val) ->
        (new TimelineEntry).initialize_from_DOM_element val, settings

    @settings = settings

    # Observe clicks on entries
    $(@settings.timeline_selector).on 'click', @settings.timeline_entry_selector, null , (evt) =>
      @timeline_entries[@entries_dom_elements.index(evt.currentTarget)].click(evt)

    # Observe category picker
    $(@settings.category_picker_form + ' input').on 'change', =>
      @reflow()

    # Observe importance slider
    $(@settings.importance_slider).on 'change', =>
      @reflow()
    this
  reflow: ->

    # helper functions
    intersection = (a, b) ->
      [a, b] = [b, a] if a.length > b.length
      value for value in a when value in b

    get_column_height = (column) ->
        if column.length > 0
          last = column[column.length - 1]
          last.cached_top_position + last.card_height()
        else
          0

    # thresholds
    acceptable_categories = $(@settings.category_picker_form + ' input:checked').map (index, value) ->
      value.value
    importance_threshold = parseInt($(@settings.importance_slider).val())

    # filter entries
    entries_to_show = []
    for entry in @timeline_entries
      if intersection(entry.categories, acceptable_categories).length > 0 and entry.importance <= importance_threshold
        # show
        entry.show()
        entries_to_show.push entry
      else
        # hide
        entry.hide()

    # calculate number of columns
    number_of_columns = parseInt($(@settings.timeline_selector).width() / (@settings.columnWidth + 2 * @settings.columnMargin))

    # dont reflow if columns and entries stay the same
    return if number_of_columns == @column_mapping.length and intersection(entries_to_show, @entries_currently_displayed).length == entries_to_show

    @entries_currently_displayed = entries_to_show

    # assign each entry a column
    @column_mapping = ( [] for i in [0..number_of_columns-1])

    for entry in entries_to_show

      minimum_height = get_column_height @column_mapping[0]
      minimal_column = 0

      for column, index in @column_mapping
        height = get_column_height column
        if height < minimum_height
          minimal_column = index
          minimum_height = height
      
      # add entry to minimal column

      @column_mapping[minimal_column].push entry

      if minimum_height == 0
        top = 0
      else
        top = minimum_height + @settings.columnMargin

      entry.$element.css
        top: top
        left: minimal_column * (@settings.columnWidth + @settings.columnMargin)

      entry.cached_top_position = top
      
    # set height of container
    maximum_height = get_column_height @column_mapping[0]
    maximum_column = 0

    for column, index in @column_mapping
      height = get_column_height column
      if height > maximum_height
        maximum_column = index
        maximum_height = height

    $(@settings.timeline_selector).css 'height', maximum_height



      

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  timelinify: (options) ->
    # Default settings
    settings =
      timeline_selector: '#about-timeline'
      timeline_entry_selector: '.about-timeline-entry'
      timeline_entry_card_selector: '.about-timeline-entry-card'
      timeline_entry_tag_selector: '.timeline-entry-tags'
      category_picker_form: '#category-picker'
      importance_slider: '#importance-slider'
      columnWidth: 300
      columnMargin: 10
      debug: false

    # Merge default settings with options.
    settings = $.extend settings, options

    # Simple logger.
    log = (msg) ->
      console?.log msg if settings.debug

    # _Insert magic here._
    return @each ()->
      entries_dom_elements = $(settings.timeline_selector + ' ' + settings.timeline_entry_selector)

      timeline_entry_manager = (new TimelineEntryManager()).initialize_from_DOM_elements entries_dom_elements, settings
      timeline_entry_manager.reflow()
      $(window).resize ->
        timeline_entry_manager.reflow()

