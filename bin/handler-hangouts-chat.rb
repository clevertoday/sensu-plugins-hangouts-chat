#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Sensu Handler: Google Hangouts Chat
#
# This handler script is used to send notifications to Google Hangouts Chat rooms.
#

require 'sensu-handler'

class HangoutsChat < Sensu::Handler
  option :json_config,
         description: 'Configuration name',
         short: '-j JSONCONFIG',
         long: '--json JSONCONFIG',
         default: 'hangouts_chat'

  def hangouts_chat_webhook_url
    get_setting('webhook_url')
  end

  def get_setting(name)
    settings[config[:json_config]][name]
  rescue TypeError, NoMethodError => e
    puts "settings: #{settings}"
    puts "hangouts chat key: #{config[:json_config]}. This should not be a file name/path."
    puts "
      key name: #{name}. This is the key in config that broke.
      Check the hangouts chat key to make sure it's parent key exists
    "
    puts "error: #{e.message}"
    exit 3 # unknown
  end

  def incident_key
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def incident_description
    @event['check']['name']
  end

  def handle
    post_data("#{incident_key}: #{incident_description}")
  end

  def post_data(body)
    uri = URI(hangouts_chat_webhook_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}", 'Content-Type' => 'application/json')
    req.body = body
    response = http.request(req)
    verify_response(response)
  end

  def verify_response(response)
    case response
    when Net::HTTPSuccess
      true
    else
      raise response.error!
    end
  end
end
