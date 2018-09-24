# frozen_string_literal: true

Bundler.setup

require 'bundler/setup'
require 'simplecov'
require 'sensu-plugins-hangouts-chat'
require 'webmock/rspec'

require_relative '../bin/handler-hangouts-chat'

WebMock.disable_net_connect!(allow_localhost: true)

SimpleCov.start
