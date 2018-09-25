# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HangoutsChat do # rubocop:disable Metrics/BlockLength
  let(:webhook_url) { 'https://example.com' }

  let(:handler) do
    HangoutsChat.disable_autorun
    handler = HangoutsChat.new
    allow(handler).to receive(:settings).and_return('hangouts_chat' => { 'webhook_url' => webhook_url })
    handler
  end

  let(:event) do
    {
      'client' => { 'name' => 'test' },
      'check' => { 'name' => 'test', 'output' => 'test' },
      'occurrences': 1
    }
  end
  let(:incident_key) { "#{event['client']['name']}/#{event['check']['name']}" }
  let(:incident_description) { event['check']['output'] }
  let(:formated_message) do
    { 'text' => "#{incident_key}: #{incident_description}" }
  end
  let(:json_formated_message) { JSON.generate(formated_message) }

  describe 'Options' do
    it 'Set the webhook_url correctly with a json_config key' do
      expect(handler.hangouts_chat_webhook_url).to eq(webhook_url)
    end

    it 'Return with a exit code 3 if the webhook_url is not set in config' do
      allow(handler).to receive(:settings).and_return({})
      expect { handler.hangouts_chat_webhook_url }.to exit_with_code(3)
    end

    it 'Set the webhook_url correctly if directly pass in option' do
      webhook_url = 'test.localhost'
      allow(handler).to receive(:config).and_return(webhook_url: webhook_url)
      expect(handler.hangouts_chat_webhook_url).to eq(webhook_url)
    end
  end

  describe 'Incident format' do
    it 'Define the incident_key correctly' do
      handler.event = event
      expect(handler.incident_key).to eq(incident_key)
    end

    it 'Define the incident_description correctly' do
      handler.event = event
      expect(handler.incident_description).to eq(incident_description)
    end

    it 'Generate the incident_formated_message correctly' do
      handler.event = event
      expect(handler.incident_formated_message).to eq(formated_message)
    end
  end

  describe 'webhook' do # rubocop:disable Metrics/BlockLength
    describe 'success' do
      before(:each) do
        stub_request(:post, /#{webhook_url}/)
          .to_return(status: 200, body: 'stubbed response', headers: {})
      end

      it 'When handle a event, call the post_data with the correct JSON formated message' do
        expect(handler).to receive(:post_data).with(json_formated_message)
        handler.event = event
        handler.handle
      end

      it 'Should have send the correct request to the webhook' do
        handler.event = event
        handler.handle
        expect(WebMock).to have_requested(:post, webhook_url)
          .with(body: json_formated_message, headers: { 'Content-Type' => 'application/json' }).once
      end
    end

    describe 'failure' do
      before(:each) do
        stub_request(:post, /#{webhook_url}/)
          .to_return(status: 500, body: 'Internal server error', headers: {})
      end

      it 'Should raise the correct exception when a server error happen' do
        handler.event = event
        expect { handler.handle }.to raise_error(Net::HTTPFatalError)
      end
    end
  end
end
