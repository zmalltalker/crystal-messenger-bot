# Crystal API for Facebook's Messenger API

Messenger bot API for [Crystal](http://crystal-lang.org/).

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  messenger-bot:
    github: zmalltalker/messenger-bot
```


## Usage

### Setting up the Messenger API

This is going to be the most time consuming task. Generally just
follow the instructions on
[the Facebook developer site](https://developers.facebook.com/docs/messenger-platform/quickstart)
to set up a page and app. You should end up with an access token,
which you'll need to actually deliver messages through Messenger.

There's an API for building message payloads for Messenger messages, and an API for sending them.
Let's say you know the id of a recipient and you have an access token
for Messenger, here's how you would go about sending a text message to
her

### Building and sending messages

Assuming you have an access token and a recipient ID, you can send a
message through Messenger like this:


```crystal
require "messenger-bot"
access_token = "REALLY_LONG_STRING_HERE"
recipient_id = 12390123112312
message = Messenger::Bot::Builder.new(recipient_id)
  .add_text("Hey Marius. I think you're a really nice guy.")
  .build

api = Messenger::Bot::GraphAPI.new("2.6", access_token)
recipient_id, message_id = api.deliver_message(message)
puts "Delivered message #{message_id} to recipient #{recipient_id}"

```

### Building a message with buttons

In addition to supporting plain text messages, this library supports
adding buttons into messages. There are two types of buttons that can
be added:

* Web links, created with `Messenger::Bot::Link.create(title : String,
url : String)
* Callback links, with a payload that can call back into your app with
  a payload. Created with `Messenger::Bot::Link.create(title : String,
  callback : String)

Example:

```crystal
require "messenger-bot"
access_token = "REALLY_LONG_STRING_HERE"
recipient_id = 12390123112312

url_link = Messenger::Bot::Link.create("Read on", url:
"https://zmalltalker.com")
callback_link = Messenger::Bot::Link.create("See more", callback:
"state returned into your bot")

message = Messenger::Bot::Builder.new(recipient_id)
  .add_text("Hey Marius")
  .add_button(url_link)
  .add_button(callback_link)
  .build

api = Messenger::Bot::GraphAPI.new("2.6", access_token)

recipient_id, message_id = api.deliver_message(message)
puts "Delivered message with buttons as message #{message_id} to recipient #{recipient_id}"
```

To build messages, see `Messenger::Bot::Builder#build`

## Incoming message thoughts

Work In Progress: Have a look at
`Messenger::Bot::IncomingMessageParser` in the meantime.

Create a Factory (in lack of a better name), which takes an incoming
JSON document and returns an IncomingMessage, with a sender id,
message text and optional quick reply.

The IncomingMessage may have attachments, either:
* FileAttachment
* Location (lat,lng)

Idea: the factory could either return an IncomingMessage or a Postback
object with a payload.

Next, to add handlers in your app, use the supplied type to perform
proper actions.

```crystal
class MyApp
def process(message : TextMessage)
# do stuff with a text message
end

def process(message : Postback)
# do stuff with a postback message
end
```

## Development

The `spec/` directory contains some tests for building and sending
messages. Right now only text type messages are supported, but I plan
on adding support for richer messages to.

This is my first Crystal project, so consider yourself warned.

If time (and interest) allows it, I'm planning to add support for
parsing incoming messages as well. This way I hope to make it possible
to build webhooks to interact with users sending you messages
too. Once this is ready you should not have any problems getting hold
of a recipient id to play with :-)

## Contributing

1. Fork it ( https://github.com/zmalltalker/messenger-bot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [zmalltalker](https://github.com/zmalltalker) Marius Mathiesen - creator, maintainer
