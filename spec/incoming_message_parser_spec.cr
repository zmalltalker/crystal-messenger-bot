require "./spec_helper"

describe Messenger::Bot::IncomingMessageParser do
  it "handles an incoming text message" do
    json = fixture("incoming_message_with_payload.json")
    docs = Messenger::Bot::IncomingMessageParser.process_json_document(json)
    doc = docs[0]
    doc.sender_id.should eq("42")
  end
end
