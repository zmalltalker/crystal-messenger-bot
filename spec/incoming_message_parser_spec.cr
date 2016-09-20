require "./spec_helper"

describe Messenger::Bot::IncomingMessageParser do
  it "handles an incoming text message" do
    json = %({
               "sender":{
                           "id":42
                         },
              "recipient":{
                             "id":"PAGE_ID"
                           },
              "timestamp":1458692752478,
              "message":{
                           "mid":"mid.1457764197618:41d102a3e1ae206a38",
                         "seq":73,
                         "text":"hello, world!",
                         "quick_reply": {
                                          "payload": "DEVELOPER_DEFINED_PAYLOAD"
                                        }
                         }
             }    )
    doc = Messenger::Bot::IncomingMessageParser.process_json_document(json)
    doc.sender_id.should eq(42)
  end
end
