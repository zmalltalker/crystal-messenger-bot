module Messenger::Bot
  class GraphAPI
    def initialize(@api_version : String, @access_token : String)
    end

    def deliver_message(message : OutgoingMessage)
      response = HTTP::Client.post("https://graph.facebook.com/v#{@api_version}/me/messages?access_token=#{@access_token}",
                                   body: message.to_json,
                                   headers: HTTP::Headers{"Content-Type" => "application/json"})
      result = GraphResponseMessage.from_json(response.body)
      return result.recipient_id, result.message_id
    end
  end
end
