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
      result = GraphResponseMessage.from_json(response.body)
      return result.recipient_id, result.message_id
    end
  end
end
