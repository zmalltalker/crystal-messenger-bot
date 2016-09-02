require "json"
module Messenger::Bot
  class RecipientPayload
    JSON.mapping({
                   recipient_id: {type: Int32, key: "id"}
                 })
    def initialize(@recipient_id : Int32)
    end
  end

  class RecipientMessage
    JSON.mapping({
                   text: String
                 })
    def initialize(@text : String)
    end
  end
  class OutgoingMessage
    JSON.mapping({
                   recipient: RecipientPayload,
                   message: RecipientMessage
                 })
    def initialize(@recipient : RecipientPayload, @message : RecipientMessage)
    end
  end

  class GraphResponseMessage
    JSON.mapping({
                   recipient_id: String,
                   message_id: String
                 })
  end
end
