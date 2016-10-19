require "json"

module Messenger
  module Bot
    module IncomingMessageParser
      extend self

      def process_json_document(json_text)
        json = JSON.parse(json_text)
        result = [] of IncomingTextMessage
        json["entry"].each do |entry|
          entry["messaging"].each do |message|
            body = message["message"]["text"].as_s
            sender_id = message["sender"]["id"].as_s
            result << IncomingTextMessage.new(body, sender_id)
          end
        end
        result
      end
    end

    class IncomingTextMessage
      getter :text, :sender_id

      def initialize(@text : String, @sender_id : String)
      end
    end
  end
end
