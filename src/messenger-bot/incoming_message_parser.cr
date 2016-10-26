require "json"

module Messenger
  module Bot
    module IncomingMessageParser
      extend self

      def process_json_document(json_text)
        json = JSON.parse(json_text)
        result = [] of IncomingMessage
        json["entry"].each do |entry|
          entry["messaging"].each do |message|
            result << parse(message)
          end
        end
        result
      end

      def parse(message)
        sender_id = message["sender"]["id"].as_s
        if message["message"]?
          body = message["message"]["text"].as_s
          IncomingTextMessage.new(body, sender_id)
        else
          payload = message["postback"]["payload"].as_s
          IncomingPayload.new(payload, sender_id)
        end
      end
    end

    class IncomingMessage
      @sender_id : String?
      getter :sender_id
    end

    class IncomingPayload < IncomingMessage
      getter :payload
      def initialize(@payload : String, @sender_id : String)
      end
    end

    class IncomingTextMessage < IncomingMessage
      getter :text

      def initialize(@text : String, @sender_id : String)
      end
    end
  end
end
