module Messenger
  module Bot
    # Build messages to be sent to Messenger users
    # Send the resulting messages using `Messenger::Bot::GraphAPI`
    class Builder
      @recipient_id : String

      def initialize(recipient_id)
        @recipient_id  = recipient_id.to_s
        @buttons = [] of Link
        @quick_actions = [] of NamedTuple(title: String, payload: String, content_type: String)
      end

      # Add message text *text* to the message
      def add_text(text : String)
        @message = text
        self
      end

      # Add a button *button* to the list of buttons to include in the message
      # Build links using `Link#create`
      def add_button(button : Link)
        @buttons << button
        self
      end

      # Build a JSON message indicating that we're busy typing
      #        %({"recipient":{"id":#{@recipient_id}}, "sender_action":"typing_on"})
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
            message_payload(io, o)
          end
        end
      end

      def message_payload(io, o)
        if @quick_actions.size > 0
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
            return
          end
        end
        if @buttons.size == 0
          o.field "message" do
            io.json_object do |message|
              message.field "text", @message
            end
          end
          return
        end
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
