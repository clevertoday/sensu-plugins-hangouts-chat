#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Sensu Handler: Google Hangouts Chat
#
# This handler script is used to send notifications to Google Hangouts Chat rooms.
#

require 'sensu-handler'

class HangoutsChat < Sensu::Handler
  def check_status
    @event['check']['status']
  end
end
