module Messenger
  module Bot
    # Build messages to be sent to Messenger users
    class Builder
      # Build a text message payload which can be delivered through the Messenger, aka Graph, API
      # Build a text message to user with id *recipient_id* with the text *message_text*
      def build_text_message(recipient_id : Int64, message_text : String)
        %({"recipient":{"id": #{recipient_id}},"message":{"text":"#{message_text}"}})
      end

      # Build a message to user *recipient_id* with message text *message* and a list *buttons*
      # of `Link` links.
      # Build links using `Link.create`
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
end
