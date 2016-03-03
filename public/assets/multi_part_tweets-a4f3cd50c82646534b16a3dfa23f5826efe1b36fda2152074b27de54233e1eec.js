(function($){
  $.fn.textareaAutoExpand = function(){
    return this.each(function(){
      var textarea = $(this);
      var height = textarea.height();
      var diff = parseInt(textarea.css('borderBottomWidth')) + parseInt(textarea.css('borderTopWidth')) + 
                 parseInt(textarea.css('paddingBottom')) + parseInt(textarea.css('paddingTop'));
      var hasInitialValue = (this.value.replace(/\s/g, '').length > 0);
      
      if (textarea.css('box-sizing') === 'border-box' || 
          textarea.css('-moz-box-sizing') === 'border-box' || 
          textarea.css('-webkit-box-sizing') === 'border-box') {
        height = textarea.outerHeight();
        
        if (this.scrollHeight + diff == height) // special case for Firefox where scrollHeight isn't full height on border-box
          diff = 0;
      } else {
        diff = 0;
      }
      
      if (hasInitialValue) {
        textarea.height(this.scrollHeight);
      }
      
      textarea.on('scroll input keyup', function(event){ // keyup isn't necessary but when deleting text IE needs it to reset height properly
        if (event.keyCode == 13 && !event.shiftKey) {
          // just allow default behavior to enter new line
          if (this.value.replace(/\s/g, '').length == 0) {
            event.stopImmediatePropagation();
            event.stopPropagation();
          }
        }
        
        textarea.height(0);
        //textarea.height(Math.max(height - diff, this.scrollHeight - diff));
        textarea.height(this.scrollHeight - diff);
      });
    });
  }
})(jQuery);
(function() {
  $.fn.extend({
    multi_part_tweet: function(options) {
      var settings;
      settings = {
        tweet_list: '#twitter-timeline-tweets',
        tweet_button: '#twitter-compose-button'
      };
      $.extend(settings, options);
      return this.each(function() {
        $.extend(this, {
          current_tweet_body: "",
          tweet_elements: [],
          template: '<li class="twitter-timeline-tweet"> <img src="https://si0.twimg.com/profile_images/1269909602/mv_carnet_normal.jpg" alt=""> <div class="tweet_body"> <header><span class="name">Martin Vasavsky</span><span class="nick">@martinvars</span></header> <div class="tweet_text">Has somebody built the Tesla equivalent in a motor boat?</div> </div> </li>',
          init: function() {
            $(this).on('change input propertychange', (function(_this) {
              return function(evt) {
                return _this.set_curreny_tweet_body($(_this).val());
              };
            })(this));
            $(settings.tweet_button).click((function(_this) {
              return function() {
                return _this.tweet();
              };
            })(this));
            return $(this).textareaAutoExpand();
          },
          set_curreny_tweet_body: function(text) {
            this.current_tweet_body = text;
            return this.display_tweet();
          },
          chunk_tweet: function() {
            var collecting_array, i, index, len, word, wordlength, words;
            if (this.current_tweet_body.length === 0) {
              return [];
            }
            words = this.current_tweet_body.split(/([\s\n\r]+)/);
            collecting_array = [];
            index = 0;
            for (i = 0, len = words.length; i < len; i++) {
              word = words[i];
              if (!collecting_array[index]) {
                collecting_array[index] = {
                  word: '',
                  length: 0
                };
              }
              wordlength = word.length;
              if (word.match(/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/gi)) {
                wordlength = 22;
              }
              if (collecting_array[index].length + wordlength < 140) {
                collecting_array[index].word += word;
                collecting_array[index].length += wordlength;
              } else {
                index += 1;
                collecting_array[index] = {};
                collecting_array[index].word = word;
                collecting_array[index].length = wordlength;
              }
            }
            return collecting_array;
          },
          display_tweet: function() {
            var chunks, to_remove, tweet, tweets_needed;
            chunks = this.chunk_tweet();
            tweets_needed = chunks.length;
            if (tweets_needed > this.tweet_elements.length) {
              if (tweets_needed === 1) {
                tweet = $(this.template);
                $(settings.tweet_list).prepend(tweet);
                this.tweet_elements = [tweet];
              } else {
                tweet = $(this.template);
                tweet.insertAfter(this.tweet_elements.slice(-1)[0]);
                this.tweet_elements.push(tweet);
              }
            } else if (tweets_needed < this.tweet_elements.length) {
              to_remove = this.tweet_elements.splice(tweets_needed);
              $(to_remove).each(function() {
                return this.remove();
              });
            }
            return $(this.tweet_elements).each(function(idx, val) {
              var text;
              text = chunks[idx].word.replace(/\n/g, "<br />");
              return $(val).find('.tweet_text').html(text);
            });
          },
          tweet: function() {
            var i, index, len, newwindow, results, tweet, tweets;
            tweets = this.chunk_tweet();
            results = [];
            for (index = i = 0, len = tweets.length; i < len; index = ++i) {
              tweet = tweets[index];
              results.push(newwindow = window.open("https://twitter.com/intent/tweet?text=" + (encodeURIComponent(tweet.word)), index + "-window", 'height=300,width=450,location=no'));
            }
            return results;
          }
        });
        return this.init();
      });
    }
  });

  $(document).on('ready', function() {
    return $('#twitter-compose-input').multi_part_tweet();
  });

}).call(this);
