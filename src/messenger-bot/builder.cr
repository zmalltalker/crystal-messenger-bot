module Messenger
  module Bot
    # Build messages to be sent to Messenger users
    # Send the resulting messages using `Messenger::Bot::GraphAPI`
    class Builder
      def initialize(@recipient_id : Int64)
      end


      # Add message text *text* to the message
      def add_text(text : String)
        @message = text
        self
      end

      # Add some link buttons to your message. Build a message with
      # message text *message* and a list *buttons* of `Link` links.
      # Build links using `Link.create`
      def add_buttons(buttons : Array(Link))
        @buttons = buttons
        self
      end


      # Build a JSON message payload which can be delivered through the Messenger, aka Graph, API
      def build
        %({"recipient":{"id": #{@recipient_id}}, #{message_payload}})
      end

                         # :nodoc:
                         def buttons : Array(Link)
                           @buttons || [] of Link
                         end

      def message_payload
        if buttons.size == 0
          %("message": {"text": "#{@message}"})
        else
          %("message": {
                "attachment": {
                    "type": "template",
                    "payload": {
                        "template_type": "button",
                        "text": "#{@message}",
                        "buttons": [#{(buttons.map &.to_json_string).join(",")}]
                    }
                }
            }
        )
        end
      end

          # Build a message to user *recipient_id* with message text *message* and a prompt
          # for the current user's location
          def build_message_with_location_prompt(message : String)
            %({
                "recipient":{
                               "id":"#{@recipient_id}"
                             },
               "message":{
                            "text":"#{message}",
                          "quick_replies":[
                                             {"content_type":"location"}
                                           ]
                          }
              }
             )
          end

    end
  end
end
