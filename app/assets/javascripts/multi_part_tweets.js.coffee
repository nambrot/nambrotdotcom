# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# = require textareaAutoExpand

# TODO:
# fetch username and nick from twitter
# post automatically
# hashtag
# indexing

$.fn.extend
  multi_part_tweet: (options) ->
    settings = 
      tweet_list: '#twitter-timeline-tweets'
      tweet_button: '#twitter-compose-button'
    $.extend settings, options

    return @each () ->
      $.extend this,
        current_tweet_body: ""
        tweet_elements: []
        template: '<li class="twitter-timeline-tweet">
      <img src="https://si0.twimg.com/profile_images/1269909602/mv_carnet_normal.jpg" alt="">
      <div class="tweet_body">
        <header><span class="name">Martin Vasavsky</span><span class="nick">@martinvars</span></header>
        <div class="tweet_text">Has somebody built the Tesla equivalent in a motor boat?</div>
      </div>
    </li>'
        init: ->
          $(this).on 'change input propertychange', (evt) =>
            @set_curreny_tweet_body $(this).val()
          $(settings.tweet_button).click =>
            @tweet()
          $(this).textareaAutoExpand()
        set_curreny_tweet_body: (text) ->
          @current_tweet_body = text
          @display_tweet()
        chunk_tweet: () ->
          return [] if @current_tweet_body.length == 0

          # split the tweet in single words
          words = @current_tweet_body.split(/([\s\n\r]+)/)
          collecting_array = []
          index = 0
          for word in words
            collecting_array[index] = {word: '', length: 0} unless collecting_array[index]

            wordlength = word.length
            # twitter caps every url to 22 chars no matter what
            if word.match(/[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi)
              wordlength = 22

            # can we still add this or what
            if collecting_array[index].length + wordlength < 140
              collecting_array[index].word += word
              collecting_array[index].length += wordlength
            else
              index += 1
              collecting_array[index] = {}
              collecting_array[index].word = word
              collecting_array[index].length = wordlength
          return collecting_array
        display_tweet: ->
          chunks = @chunk_tweet()
          # calculate how many tweets we need
          tweets_needed = chunks.length

          if tweets_needed > @tweet_elements.length
            if tweets_needed == 1
              tweet = $ @template
              $(settings.tweet_list).prepend tweet
              @tweet_elements = [tweet]
            else
              tweet = $ @template
              tweet.insertAfter @tweet_elements.slice(-1)[0]
              @tweet_elements.push tweet
          else if tweets_needed < @tweet_elements.length
            to_remove = @tweet_elements.splice(tweets_needed)
            $(to_remove).each ->
              @remove()

          $(@tweet_elements).each (idx, val) ->
            # replace newlines with br tags
            text = chunks[idx].word.replace /\n/g, "<br />"
            $(val).find('.tweet_text').html(text)
        tweet: ->
          tweets = @chunk_tweet()
          for tweet, index in tweets
            newwindow = window.open("https://twitter.com/intent/tweet?text=#{encodeURIComponent(tweet.word)}", "#{index}-window" ,'height=300,width=450,location=no')

      @init()

$(document).on 'ready', ->
  $('#twitter-compose-input').multi_part_tweet()

