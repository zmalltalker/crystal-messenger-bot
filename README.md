# messenger-bot

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

```crystal
require "messenger-bot"
access_token = "REALLY_LONG_STRING_HERE"
recipient_id = 12390123112312
message = Messenger::Bot::Builder.new.build_text_message(recipient_id, "Hey Marius. I think you're a really nice guy.")
api = Messenger::Bot::GraphAPI.new("2.6", access_token)
recipient_id, message_id = api.deliver_message(message)
puts "Delivered message #{message_id} to recipient #{recipient_id}"

```

## Development

The `spec/` directory contains some tests for building and sending
messages. Right now only text type messages are supported, but I plan
on adding support for richer messages to.

This is my first Crystal project, so consider yourself warned.

## Contributing

1. Fork it ( https://github.com/zmalltalker/messenger-bot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [zmalltalker](https://github.com/zmalltalker) Marius Mathiesen - creator, maintainer
