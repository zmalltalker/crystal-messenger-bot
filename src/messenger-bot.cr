require "./messenger-bot/*"
require "http/client"

module Messenger::Bot
  class Builder
    def build_text_message(recipient_id : Int64, message_text : String)
      %({"recipient":{"id": #{recipient_id}},"message":{"text":"#{message_text}"}})
                      end
                       def build_message_with_buttons(recipient_id : Int64, message : String, buttons : Array(Link))
                         %({
            "recipient": {
                "id": #{recipient_id}
            },
            "message": {
                "attachment": {
                    "type": "template",
                    "payload": {
                        "template_type": "button",
                        "text": "#{message}",
                        "buttons": [#{(buttons.map &.to_json_string).join(",")}]
                    }
                }
            }
        })
                       end
  end
end
