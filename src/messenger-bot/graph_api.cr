module Messenger::Bot
  # A wrapper for Facebook's Graph API
  class GraphAPI
    # Build an API instance with which you can send messages.
    # Pass *api_version* (current is 2.6) an *access_token*, which you need to
    # authenticate yourself to the Graph API
    def initialize(@api_version : String, @access_token : String)
    end

    # Deliver a pre-built JSON message *message* through the Graph API
    # Returns the delivered message's recipient id and message id
    # Error handling not really built-in.
    def deliver_message(message : String)
      response = HTTP::Client.post("https://graph.facebook.com/v#{@api_version}/me/messages?access_token=#{@access_token}",
        body: message,
        headers: HTTP::Headers{"Content-Type" => "application/json"})
      begin
        result = GraphResponseMessage.from_json(response.body)
        return result.recipient_id, result.message_id
      rescue ex
        puts ex.message
        puts response.body
        return 0, 0
      end
    end

    def user_name(user_id : Int64): String
      response = HTTP::Client.get("https://graph.facebook.com/v#{@api_version}/#{user_id}?fields=first_name,last_name&access_token=#{@access_token}",
                                  headers: HTTP::Headers{"Content-Type" => "application/json"})
      result = JSON.parse(response.body)
      return %(#{result["first_name"]} #{result["last_name"]})
    end

    # Notify the user that we're working on a response, and then deliver the
    # final message once it's ready
    # This is still work in progress, reading up on https://crystal-lang.org/docs/guides/concurrency.html
    def deferred_send(recipient_id : Int64, channel : Channel(GraphAPI))
      spawn do
        message = Builder.new(recipient_id)
                  .build_wait_message
        deliver_message(message)
        channel.send(self)
      end
    end
  end
end
