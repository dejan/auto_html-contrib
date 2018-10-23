require 'tag_helper'

module AutoHtml
  # YouTube filter
  class YouTube
    include TagHelper

    def initialize(width: 420, height: 315, lazy: false)
      @width = width
      @height = height
      @lazy = lazy
    end

    def call(text)
      text.gsub(youtube_pattern) do
        no_href_attr = Regexp.last_match(1).nil?
        if no_href_attr
          youtube_id = Regexp.last_match(5)
          tag(:div, class: 'video youtube') do
            tag(:div, class: 'responsive-embed') do
              tag(:iframe, iframe_attributes(youtube_id)) { '' }
            end
          end
        else
          # No transformation if matches a href attr
          Regexp.last_match(0)
        end
      end
    end

    private

    def youtube_pattern
      @youtube_pattern ||=
        %r{
          (href=['"])?
          (https?://)?
          (www.)?
          (
            youtube\.com/watch\?v=|
            youtu\.be/|
            youtube\.com/watch\?feature=player_embedded&v=
          )
          ([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?
        }x
    end

    def iframe_attributes(youtube_id)
      src = "//www.youtube.com/embed/#{youtube_id}"
      attrs = {
        width: @width,
        height: @height,
        'data-src': src,
        frameborder: 0,
        allowfullscreen: 'yes'
      }
      if @lazy
        attrs['data-src'] = src
        attrs[:class] = 'lazyload'
      else
        attrs[:src] = src
      end
      attrs
    end
  end
end
