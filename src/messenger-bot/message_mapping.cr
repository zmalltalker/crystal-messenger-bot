require "json"
module Messenger::Bot

  class GraphResponseMessage
    JSON.mapping({
                   recipient_id: String,
                   message_id: String
                 })
  end
end
