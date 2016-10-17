require "json"

module Messenger
  module Bot
    # Represent links to be embedded in messages
    class Link
      # Create a Link with *title* and either *url* or *callback*
      # Both will be displayed as links in messenger with *title* as link text,
      # but links with *callback* will link back to the both with this payload while
      # links with *url*  will link to a website.
      def self.create(title : String, url : String = nil, callback : String = nil)
        if url
          URLLink.new(title, url)
        elsif callback
          CallbackLink.new(title, callback)
        else
          raise "Need either callback or url"
        end
      end

      # :nodoc:
      def to_json_string
        raise "Not implemented"
      end

      def to_json(io : IO)
        to_tuple.to_json(io)
      end

      def to_tuple
        raise "Not implemented"
      end
    end

    # :nodoc:
    class URLLink < Link
      getter :title, :url

      def initialize(@title : String, @url : String)
      end

      def to_json_string
        %({"title":"#{@title}", "type":"web_url", "url": "#{@url}"})
      end

      def to_tuple
        {"title" : @title, "type" : "web_url", "url" : @url}
      end
    end

    # :nodoc:
    class CallbackLink < Link
      getter :title, :callback

      def initialize(@title : String, @callback : String)
      end

      def to_json_string
        %({"title":"#{@title}", "type":"postback", "payload":"#{@callback}"})
      end

      def to_tuple
        {"title" : @title, "type" : "postback", "payload" : @callback}
      end
    end
  end
end
