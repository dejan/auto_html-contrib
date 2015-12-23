require 'tag_helper'

module AutoHtml
  # Google Maps filter
  class GoogleMaps
    include TagHelper

    def initialize(width: 420, height: 315, type: :normal, zoom: 18, show_info: false)
      @width = width
      @height = height
      @type = type
      @zoom = zoom
      @show_info = show_info
    end

    def call(text)
      regex = %r{(https?)://maps\.google\.([a-z\.]+)/maps\?(.*)}
      text.gsub(regex) do
        country = Regexp.last_match(2)
        path = "//maps.google.#{country}/maps"
        query = Regexp.last_match(3)
        link = link_tag(path, query)
        iframe_tag(path, query) << tag(:br) << tag(:small) { link }
      end
    end

    private

    def iframe_tag(path, map_query)
      params = ['f=q', 'source=s_q', map_query, 'output=embed'] + map_options
      tag(
        :iframe,
        width: @width,
        height: @height,
        frameborder: 0,
        scrolling: 'no',
        marginheight: 0,
        marginwidth: 0,
        src: path + '?' + params.join('&amp;')) { '' }
    end

    def link_tag(path, map_query)
      params = ['f=q', 'source=embed', map_query]
      tag(
        :a,
        href: path + '?' + params.join('&amp;'),
        style: 'color:#000;text-align:left') do
          'View Larger Map'
        end
    end

    def map_options
      map_options = []
      map_options << 'iwloc=near' if @show_info
      map_options << map_types[@type]
      map_options << "z=#{@zoom}"
    end

    def map_types
      @map_types ||= {
        normal: 't=m',
        satellite: 't=k',
        terrain: 't=p',
        hibrid: 't=h'
      }
    end
  end
end
