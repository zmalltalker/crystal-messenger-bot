module Messenger
  module Bot
    # Build messages to be sent to Messenger users
    # Send the resulting messages using `Messenger::Bot::GraphAPI`
    class Builder
      @recipient_id : String

      alias ElementType = NamedTuple(title: String, item_url: String|Nil, image_url: String|Nil, subtitle: String|Nil, buttons: Array(Link)|Nil)

      def initialize(recipient_id)
        @recipient_id  = recipient_id.to_s
        @buttons = [] of Link
        @quick_actions = [] of NamedTuple(title: String, payload: String, content_type: String)
        @elements = [] of ElementType
        @message_type = :text
      end

      # Add message text *text* to the message
      def add_text(text : String)
        @message = text
        self
      end

      def add_element(element : ElementType)
        @message_type = :generic_template
        @elements << element
        self
      end

      # Add a button *button* to the list of buttons to include in the message
      # Build links using `Link#create`
      def add_button(button : Link)
        @message_type = :buttons
        @buttons << button
        self
      end

      # Build a JSON message indicating that we're busy typing
      def build_wait_message
        String.build do |io|
          io.json_object do |o|
            o.field "recipient" do
              io.json_object { |recipient|
                recipient.field "id", @recipient_id
              }
            end
            o.field "sender_action", "typing_on"
          end
        end
      end

      # Adds quick, pre-defined actions which call back into the bot
      def add_quick_reply(values : NamedTuple(title: String, payload: String))
        @message_type = :quick_actions
        @quick_actions << {title: values[:title][0..19], payload: values[:payload], content_type: "text"}
        self
      end

      # Build a JSON message payload which can be delivered through the Messenger, aka Graph, API
      def build
        String.build do |io|
          io.json_object do |o|
            o.field "recipient" do
              io.json_object do |recipient|
                recipient.field "id", @recipient_id
              end
            end
            append_message_payload(io, o)
          end
        end
      end

      # :nodoc:
      # Append message payload based on message type
      def append_message_payload(io : IO, o : JSON::ObjectBuilder)
        case @message_type
        when :quick_actions
          append_quick_actions(io, o)
        when :buttons
          append_buttons(io, o)
        when :generic_template
          append_generic_template(io, o)
        else # default is text
          append_text_message(io, o)
        end
      end

      def append_generic_template(io : IO, o : JSON::ObjectBuilder)
        o.field "message" do
          io.json_object do |message|
            message.field "attachment" do
              io.json_object do |attachment|
                attachment.field "type", "template"
                attachment.field "payload" do
                  io.json_object do |payload|
                    payload.field "template_type", "generic"
                    payload.field "elements" do
                      io.json_array do |elements|
                        @elements.each do |element|
                          elements << element
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      # :nodoc:
      # Append quick actions payload
      def append_quick_actions(io : IO, o : JSON::ObjectBuilder)
        o.field "message" do
          io.json_object do |message|
            message.field "text", @message
            message.field "quick_replies" do
              io.json_array do |array|
                @quick_actions.each do |a|
                  array << a
                end
              end
            end
          end
        end
      end

      # :nodoc:
      # Append payload for text message
      def append_text_message(io : IO, o : JSON::ObjectBuilder)
        o.field "message" do
          io.json_object do |message|
            message.field "text", @message
          end
        end
      end

      # :nodoc:
      # Append payload for button type message
      def append_buttons(io : IO, o : JSON::ObjectBuilder)
        o.field "message" do
          io.json_object do |message|
            message.field "attachment" do
              io.json_object do |attachment|
                attachment.field "type", "payload"
                attachment.field "payload" do
                  io.json_object do |payload|
                    payload.field "template_type", "button"
                    payload.field "text", @message
                    payload.field "buttons" do
                      io.json_array do |array|
                        @buttons.each do |button|
                          array << button.to_tuple
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      # Build a message to user *recipient_id* with message text *message* and a prompt
      # for the current user's location
      def build_message_with_location_prompt(message : String)
        return String.build do |io|
          io.json_object do |o|
            o.field "recipient" do
              io.json_object do |recipient|
                recipient.field "id", @recipient_id
              end
            end
            o.field "message" do
              io.json_object do |msg|
                msg.field "text", message
                msg.field "quick_replies" do
                  io.json_array do |array|
                    array << {"content_type" : "location"}
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
