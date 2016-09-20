require "./spec_helper"

describe Messenger::Bot do
  it "builds a message" do
    builder = Messenger::Bot::Builder.new
    recipient_id = 420_000_000_000
    result_text = builder.build_text_message(recipient_id, "Whoa")
    json_object = JSON.parse(result_text)
    json_object["recipient"]["id"].should eq(recipient_id)
    json_object["message"]["text"].should eq("Whoa")
  end

  it "delivers a message to Messenger's API" do
    message = Messenger::Bot::Builder.new.build_text_message(42_000_000_000, "Hullo there")
    access_token = "sikret"
    api = Messenger::Bot::GraphAPI.new("2.6", access_token)
    WebMock.stub(:post, "https://graph.facebook.com/v2.6/me/messages?access_token=#{access_token}").
      with(body: message, headers: {"Content-Type" => "application/json"}).
      to_return(status: 200, body: "{\"recipient_id\":\"42\",\"message_id\":\"mid.1234\"}")

    recipient_id, message_id  = api.deliver_message(message)
    recipient_id.should eq("42")
    message_id.should eq("mid.1234")
  end

  it "builds a message with links" do
    first_link = Messenger::Bot::Link.create("Read on", callback: "hullo")
    first_link.callback.should eq("hullo")
    second_link = Messenger::Bot::Link.create("Facebook", url: "https://facebook.com")
    result = Messenger::Bot::Builder.new.build_message_with_buttons(42_000_000_000, "Whatever", [first_link, second_link])

    obj = JSON.parse(result)
    first_button = obj["message"]["attachment"]["payload"]["buttons"][0]
    first_button["payload"].should eq("hullo")
  end

  it "builds a message with a location prompt" do
    payload = Messenger::Bot::Builder.new.build_message_with_location_prompt(42_000_000_000, "I need to know your whereabouts, pardner")

    obj = JSON.parse(payload)
    obj["message"]["text"].should eq("I need to know your whereabouts, pardner")
    obj["message"]["quick_replies"][0]["content_type"].should eq("location")
  end
end
