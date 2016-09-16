require "./messenger-bot/*"
require "http/client"

module Messenger::Bot
  class Builder
    def build_text_message(recipient_id : Int64, message_text : String)
      %({"recipient":{"id":#{recipient_id}},"message":{"text":"#{message_text}"}})
    end
  end
end
