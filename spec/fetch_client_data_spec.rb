require 'spec_helper'
require 'shiftcare_cli/fetch_client_data'

RSpec.describe ShiftCareCLI::FetchClientData do
  let(:url) { 'https://appassets02.shiftcare.com/manual/clients.json' }

  let(:sample_response) do
    [
      {
        "id" => 1,
        "full_name" => "John Doe",
        "email" => "john.doe@gmail.com"
      },
      {
        "id" => 2,
        "full_name" => "Jane Smith",
        "email" => "jane.smith@yahoo.com"
      }
    ]
  end

  context 'when the request is successful' do
    before do
      stub_request(:get, url)
        .to_return(status: 200, body: sample_response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'fetches and parses JSON data from URL' do
      result = described_class.fetch(url)
      expect(result).to be_an(Array)
      expect(result.first).to include('id', 'full_name', 'email')
    end
  end

  context 'when the response is non-200' do
    before do
      stub_request(:get, url).to_return(status: 500, body: 'Internal Server Error')
    end

    it 'raises an error for non-200 response' do
      expect { described_class.fetch(url) }.to raise_error(RuntimeError, /HTTP request failed with code 500/)
    end
  end

  context 'when the response has invalid JSON' do
    before do
      stub_request(:get, url).to_return(status: 200, body: 'invalid_json')
    end

    it 'raises a JSON parse error' do
      expect { described_class.fetch(url) }.to raise_error(RuntimeError, /Failed to parse JSON/)
    end
  end

  context 'when there is a timeout' do
    before do
      stub_request(:get, url).to_timeout
    end

    it 'raises a timeout error' do
      expect { described_class.fetch(url) }.to raise_error(Net::OpenTimeout)
    end
  end
end
