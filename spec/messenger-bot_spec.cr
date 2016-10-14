require "./spec_helper"

describe Messenger::Bot do
  it "builds a message" do
    recipient_id = 420_000_000_000

    builder = Messenger::Bot::Builder.new(recipient_id)
    builder.add_text("Whoa")

    result_text = builder.message_payload
    json_object = JSON.parse(result_text)
#    json_object["recipient"]["id"].should eq(recipient_id)
    json_object["message"]["text"].should eq("Whoa")
  end

  it "delivers a message to Messenger's API" do
    message = Messenger::Bot::Builder.new(42_000_000_000).add_text("Hullo there").build
    access_token = "sikret"
    api = Messenger::Bot::GraphAPI.new("2.6", access_token)
    WebMock.stub(:post, "https://graph.facebook.com/v2.6/me/messages?access_token=#{access_token}")
      .with(body: message, headers: {"Content-Type" => "application/json"})
      .to_return(status: 200, body: "{\"recipient_id\":\"42\",\"message_id\":\"mid.1234\"}")

    recipient_id, message_id = api.deliver_message(message)
    recipient_id.should eq("42")
    message_id.should eq("mid.1234")
  end

  it "builds a message with links" do
    first_link = Messenger::Bot::Link.create("Read on", callback: "hullo")
    first_link.callback.should eq("hullo")
    second_link = Messenger::Bot::Link.create("Facebook", url: "https://facebook.com")
    result = Messenger::Bot::Builder.new(42_000_000_000).add_text("Whatever")
             .add_button(first_link)
             .add_button(second_link)
             .message_payload

    obj = JSON.parse(result)

    first_button = obj["message"]["attachment"]["payload"]["buttons"][0]
    first_button["payload"].should eq("hullo")
  end

  it "builds a message with a location prompt" do
    payload = Messenger::Bot::Builder.new(42_000_000_000).build_message_with_location_prompt("I need to know your whereabouts, pardner")

    obj = JSON.parse(payload)
    obj["message"]["text"].should eq("I need to know your whereabouts, pardner")
    obj["message"]["quick_replies"][0]["content_type"].should eq("location")
  end

  it "builds a message with quick replies" do
    builder = Messenger::Bot::Builder.new(42_000_000_000)
    builder.add_text("Hello there")
    builder.add_quick_reply({title: "Red", payload: "RED_PAYLOAD"})

    obj = JSON.parse(builder.message_payload)
    obj["message"]["quick_replies"][0]["title"].should eq("Red")
    obj["message"]["quick_replies"][0]["payload"].should eq("RED_PAYLOAD")
  end

  it "limits the number of characters in a button to 20" do
    builder = Messenger::Bot::Builder.new(42_000_000_000)
    builder.add_text("Hello there")
    builder.add_quick_reply({title: "This text is way more than 20 characters.", payload: "RED_PAYLOAD"})

    obj = JSON.parse(builder.message_payload)
    obj["message"]["quick_replies"][0]["title"].should eq("This text is way mor")
  end

  it "builds a 'typing' message" do
    builder = Messenger::Bot::Builder.new(42_000_000_000)
    payload = builder.build_wait_message
    result = JSON.parse(payload)
    result["sender_action"].should eq("typing_on")
  end
end
