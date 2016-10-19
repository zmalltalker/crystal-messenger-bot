require "json"

module Messenger
  module Bot
    module IncomingMessageParser
      extend self

      def process_json_document(json_text)
        json = JSON.parse(json_text)
        json["entry"].map do |entry|
          body = entry["message"]["text"].as_s
          sender_id = entry["sender"]["id"].as_i64
          IncomingTextMessage.new(body, sender_id)
        end
      end
    end

    class IncomingTextMessage
      getter :text, :sender_id

      def initialize(@text : String, @sender_id : Int64)
      end
    end
  end
end
