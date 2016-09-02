require "./messenger-bot/*"

module Messenger::Bot
  class Builder
    def build_text_message(recipient_id : Int, message_text : String)
      recipient = RecipientPayload.new(recipient_id)
      message = RecipientMessage.new(message_text)
      OutgoingMessage.new(recipient, message)
    end
  end
end
