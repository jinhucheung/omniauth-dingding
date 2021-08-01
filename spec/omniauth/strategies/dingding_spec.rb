RSpec.describe OmniAuth::Strategies::Dingding do
  let(:client) { OAuth2::Client.new('client_id', 'client_secret') }
  let(:app) { -> { [200, {}, ['Hello.']] } }
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }

  subject do
    OmniAuth::Strategies::Dingding.new(app, 'client_id', 'client_secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  context '#client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('dingding')
    end

    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://oapi.dingtalk.com')
    end
  end
end