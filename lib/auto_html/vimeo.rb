require 'tag_helper'

module AutoHtml
  # Vimeo filter
  class Vimeo
    include TagHelper

    def initialize(width: 420, height: 315, allow_fullscreen: true)
      @width = width
      @height = height
      @allow_fullscreen = allow_fullscreen
    end

    def call(text)
      text.gsub(vimeo_pattern) do
        vimeo_id = Regexp.last_match(2)
        src = src_url(vimeo_id)
        tag(:div, class: 'video vimeo') do
          tag(:iframe, { src: src }.merge(iframe_attributes)) { '' }
        end
      end
    end

    private

    def vimeo_pattern
      @vimeo_pattern ||= %r{(?<!href=["'])https?://(www.)?vimeo\.com/([A-Za-z0-9._%-]*)((\?|#)\S+)?}
    end

    def src_url(vimeo_id)
      "//player.vimeo.com/video/#{vimeo_id}"
    end

    def iframe_attributes
      {}.tap do |attrs|
        attrs[:width] = @width
        attrs[:height] = @height
        attrs[:frameborder] = 0
        attrs.merge!(fullscreen_attributes) if @allow_fullscreen
      end
    end

    def fullscreen_attributes
      {
        webkitallowfullscreen: 'yes',
        mozallowfullscreen: 'yes',
        allowfullscreen: 'yes'
      }
    end
  end
end
