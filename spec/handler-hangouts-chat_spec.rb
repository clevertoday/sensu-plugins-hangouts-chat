# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HangoutsChat do # rubocop:disable Metrics/BlockLength
  let(:webhook_url) { 'https://example.com' }

  let(:handler) do
    HangoutsChat.disable_autorun
    handler = HangoutsChat.new
    allow(handler).to receive(:settings).and_return('hangouts_chat': { 'webhook_url': webhook_url })
    handler
  end

  let(:event) do
    {
      'client': { 'name': 'test' },
      'check': { 'name': 'test' },
      'occurrences': 1
    }
  end

  before(:each) do
    stub_request(:post, /#{webhook_url}/)
      .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
      .to_return(status: 200, body: 'stubbed response', headers: {})
  end

  it 'Should set the webhook_url correctly' do
    expect(handler.hangouts_chat_webhook_url).to eq(webhook_url)
  end

  it 'Send a message to the webhook when receive a event' do
    handler.event = event
    expect(handler.handle).to eq(true)
  end
end
