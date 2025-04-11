require 'spec_helper'
require 'shiftcare_cli/client'

RSpec.describe ShiftCareCLI::Client do
  let(:attrs) { { 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' } }

  let(:clients) do
    [
      described_class.new({ 'id' => 1, 'full_name' => 'Alice Smith', 'email' => 'alice@example.com' }),
      described_class.new({ 'id' => 2, 'full_name' => 'Bob Jones', 'email' => 'bob@example.com' }),
      described_class.new({ 'id' => 3, 'full_name' => 'Alicia Keys', 'email' => 'alicia@example.com' }),
      described_class.new({ 'id' => 4, 'full_name' => '', 'email' => 'unknown@example.com' }),
      described_class.new({ 'id' => 5, 'full_name' => nil, 'email' => 'nilname@example.com' }),
      described_class.new({ 'id' => 6, 'full_name' => 'David', 'email' => nil }),
      described_class.new({ 'id' => 7, 'full_name' => 'Charlie', 'email' => '' }),
      described_class.new({ 'id' => 8, 'full_name' => 'Eve', 'email' => 'Test@Example.com' }),
      described_class.new({ 'id' => 9, 'full_name' => 'Eva', 'email' => 'test@example.com' })
    ]
  end

  describe '#initialize' do
    it 'initializes with correct attributes' do
      client = described_class.new(attrs)
      expect(client.id).to eq(1)
      expect(client.full_name).to eq('Alice')
      expect(client.email).to eq('alice@example.com')
    end

    it 'handles missing fields gracefully' do
      client = described_class.new({})
      expect(client.id).to be_nil
      expect(client.full_name).to be_nil
      expect(client.email).to be_nil
    end
  end

  describe '.search_by' do
    it 'returns matching clients when query matches full_name (case insensitive)' do
      result = described_class.search_by(clients, 'full_name', 'ali')
      expect(result.map(&:full_name)).to contain_exactly('Alice Smith', 'Alicia Keys')
    end

    it 'returns empty array when query does not match any full_name' do
      result = described_class.search_by(clients, 'full_name', 'xyz')
      expect(result).to be_empty
    end

    it 'returns empty array when client full_name is nil or empty' do
      result = described_class.search_by(clients, 'full_name', 'unknown')
      expect(result).to be_empty
    end

    it 'returns empty array when given an empty clients list' do
      result = described_class.search_by([], 'email', 'Alice')
      expect(result).to eq([])
    end

    it 'returns an empty array when query is empty string' do
      result = described_class.search_by(clients, 'full_name', '')
      expect(result).to eq([])
    end
  end

  describe '.find_duplicates' do
    it 'returns a hash of duplicate emails' do
      result = described_class.find_duplicates(clients)
      expect(result.keys).to include('test@example.com')
      expect(result['test@example.com'].size).to eq(2)
    end

    it 'detects duplicates correctly when emails are repeated' do
      duplicate_clients = clients.select { |c| ['alice@example.com', 'alice@example.com'].include?(c.email) } +
                          [described_class.new({ 'id' => 10, 'full_name' => 'Clone', 'email' => 'alice@example.com' })]

      result = described_class.find_duplicates(duplicate_clients)
      expect(result['alice@example.com'].size).to eq(2)
    end

    it 'returns empty hash when there are no duplicates' do
      unique_clients = clients.select { |c| c.email && !c.email.strip.empty? }.uniq { |c| c.email }
      result = described_class.find_duplicates(unique_clients)
      expect(result).to eq({})
    end

    it 'ignores clients with nil or empty email fields' do
      result = described_class.find_duplicates(clients)
      expect(result.keys).not_to include('', nil)
    end
  end
end
