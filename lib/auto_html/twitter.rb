require 'uri'
require 'net/http'
require 'json'

module AutoHtml
  # Twitter filter
  class Twitter
    def call(text)
      text.gsub(twitter_pattern) do |match|
        uri = URI('https://api.twitter.com/1/statuses/oembed.json')
        uri.query = URI.encode_www_form(url: match)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = JSON.parse(http.get(uri.request_uri).body)
        response['html']
      end
    end

    private

    def twitter_pattern
      @twitter_pattern ||= %r{(?<!href=")https://twitter\.com(/#!)?/[A-Za-z0-9_]{1,15}/status(es)?/\d+}
    end
  end
end
