require "json"

module Messenger
  module Bot
    class Link
      def self.create(title : String, url : String = nil, callback : String = nil)
        if url
          URLLink.new(title, url)
        elsif callback
          CallbackLink.new(title, callback)
        else
          raise "Need either callback or url"
        end
      end

      def to_json_string
        raise "Not implemented"
      end
    end

    class URLLink < Link
      getter :title, :url

      def initialize(@title : String, @url : String)
      end

      def to_json_string
        %({"title":"#{@title}", "type":"web_url", "url": "#{@url}"})
      end
    end

    class CallbackLink < Link
      getter :title, :callback

      def initialize(@title : String, @callback : String)
      end

      def to_json_string
        %({"title":"#{@title}", "type":"postback", "payload":"#{@callback}"})
      end
    end
  end
end
