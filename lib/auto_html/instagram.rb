require 'tag_helper'

module AutoHtml
  # Instagram filter
  class Instagram
    include TagHelper

    def initialize(width: 616, height: 714)
      @width = width
      @height = height
    end

    def call(text)
      text << '/' unless text.end_with?('/')
      text.gsub(instagram_pattern) do
        tag(
          :iframe,
          src: "#{text}embed",
          height: @height,
          width: @width,
          frameborder: 0,
          scrolling: 'no') { '' }
      end
    end

    private

    def instagram_pattern
      @instagram_pattern ||= %r{https?:\/\/(www.)?instagr(am\.com|\.am)/p/.+}
    end
  end
end
