# sensu-plugins-hangouts-chat
[![Build Status](https://travis-ci.org/clevertoday/sensu-plugins-hangouts-chat.svg?branch=master)](https://travis-ci.org/clevertoday/sensu-plugins-hangouts-chat)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-hangouts-chat.svg)](http://badge.fury.io/rb/sensu-plugins-hangouts-chat)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4ed4e715bf90cbe6422/maintainability)](https://codeclimate.com/github/clevertoday/sensu-plugins-hangouts-chat/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d4ed4e715bf90cbe6422/test_coverage)](https://codeclimate.com/github/clevertoday/sensu-plugins-hangouts-chat/test_coverage)

## Files

 - `bin/handler-hangouts-chat.rb`

## Usage

After installation, you have to set up a pipe type handler, like so:

```json
{
  "handlers": {
    "hangouts_chat": {
      "type": "pipe",
      "command": "handler-hangouts-chat.rb"
    }
  }
}
```

This gem also expects a JSON configuration file with the following contents:


```json
{
  "hangouts_chat": {
    "webhook_url": "YOUR_WEBHOOK_URL",
  }
}
```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Testing

```bash
cat <<EOF | bundle exec bin/handler-hangouts-chat.rb -u "WEBHOOK_URL"
{
  "client": {
    "name": "client"
  },
  "check": {
    "status": 1,
    "name": "name",
    "source": "source",
    "output": "Hello, warning"
  }
}
EOF
```
