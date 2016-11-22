require 'tag_helper'

module AutoHtml
  # YouTube filter
  class YouTube
    include TagHelper

    def initialize(width: 420, height: 315, hide_related: false)
      @width = width
      @height = height
      @hide_related = hide_related
    end

    def call(text)
      text.gsub(youtube_pattern) do
        youtube_id = Regexp.last_match(4)
        tag(:div, class: 'video youtube') do
          tag(:iframe, iframe_attributes(youtube_id)) { '' }
        end
      end
    end

    private

    def youtube_pattern
      @youtube_pattern ||=
        %r{
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
      params = []
      params << "rel=0" if @hide_related
      src += "?#{params.join '&'}" unless params.empty?
      {
        width: @width,
        height: @height,
        src: src,
        frameborder: 0,
        allowfullscreen: 'yes'
      }
    end
  end
end
