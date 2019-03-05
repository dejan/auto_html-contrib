require 'tag_helper'

module AutoHtml
  # Vimeo filter
  class Vimeo
    include TagHelper

    def initialize(width: 420, height: 315, allow_fullscreen: true, lazy: false)
      @width = width
      @height = height
      @allow_fullscreen = allow_fullscreen
      @lazy = lazy
    end

    def call(text)
      text.gsub(vimeo_pattern) do
        vimeo_id = Regexp.last_match(2)
        tag(:div, class: 'video vimeo') do
          tag(:div, class: 'responsive-embed') do
            tag(:iframe, iframe_attributes(vimeo_id)) { '' }
          end
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

    def iframe_attributes(vimeo_id)
      src = src_url(vimeo_id)
      {}.tap do |attrs|
        attrs[:width] = @width
        attrs[:height] = @height
        attrs[:frameborder] = 0
        attrs.merge!(fullscreen_attributes) if @allow_fullscreen    
        if @lazy
          attrs['data-src'] = src
          attrs[:class] = 'lazyload'
        else
          attrs[:src] = src
        end
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
