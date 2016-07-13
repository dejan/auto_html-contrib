require 'tag_helper'

module AutoHtml
  # YouTube filter
  class YouTubeThumbnail
    include TagHelper

    def call(text)
      text.gsub(youtube_pattern) do
        youtube_id = Regexp.last_match(4)
        tag(:div, class: 'thumbnail youtube') do
          tag(:img, src: "http://img.youtube.com/vi/#{youtube_id}/0.jpg")
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
  end
end
