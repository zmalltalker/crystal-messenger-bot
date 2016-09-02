require "./spec_helper"

describe Messenger::Bot do
  it "builds a message" do
    builder = Messenger::Bot::Builder.new
    result = builder.build_text_message(420_000_000_000, "Whoa")
    result.recipient.recipient_id.should eq(420_000_000_000)
    result.message.text.should eq("Whoa")
  end

  it "delivers a message to Messenger's API" do
    message = Messenger::Bot::Builder.new.build_text_message(42_000_000_000, "Hullo there")
    access_token = "sikret"
    api = Messenger::Bot::GraphAPI.new("2.6", access_token)
    WebMock.stub(:post, "https://graph.facebook.com/v2.6/me/messages?access_token=#{access_token}").
      with(body: message.to_json, headers: {"Content-Type" => "application/json"}).
      to_return(status: 200, body: "{\"recipient_id\":\"42\",\"message_id\":\"mid.1234\"}")

    recipient_id, message_id  = api.deliver_message(message)
    recipient_id.should eq("42")
    message_id.should eq("mid.1234")
  end
end
