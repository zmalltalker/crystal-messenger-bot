# messenger-bot

Messenger bot API for Crystal.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  messenger-bot:
    github: zmalltalker/messenger-bot
```


## Usage


```crystal
require "messenger-bot"
```


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

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/zmalltalker/messenger-bot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [zmalltalker](https://github.com/zmalltalker) Marius Mathiesen - creator, maintainer
