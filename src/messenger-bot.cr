require "./messenger-bot/*"
require "http/client"

module Messenger::Bot
  class Builder
    def build_text_message(recipient_id : Int64, message_text : String)
      recipient = RecipientPayload.new(recipient_id)
      message = RecipientMessage.new(message_text)
      OutgoingMessage.new(recipient, message)
    end
  end
end
