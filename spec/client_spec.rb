require 'spec_helper'
require 'shiftcare_cli/client'

RSpec.describe ShiftCareCLI::Client do
  let(:attrs) { { 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' } }

  describe '#initialize' do
    it 'initializes with correct attributes' do
      client = described_class.new(attrs)
      expect(client.id).to eq(1)
      expect(client.full_name).to eq('Alice')
      expect(client.email).to eq('alice@example.com')
    end
  end

  describe '.search_by_name' do
    let(:clients) do
      [
        described_class.new({ 'id' => 1, 'full_name' => 'Alice Smith', 'email' => 'alice@example.com' }),
        described_class.new({ 'id' => 2, 'full_name' => 'Bob Jones', 'email' => 'bob@example.com' }),
        described_class.new({ 'id' => 3, 'full_name' => 'Alicia Keys', 'email' => 'alicia@example.com' })
      ]
    end

    it 'returns matching clients when name includes query' do
      result = described_class.search_by_name(clients, 'ali')
      expect(result.size).to eq(2)
      expect(result.map(&:full_name)).to contain_exactly('Alice Smith', 'Alicia Keys')
    end

    it 'returns empty array when no match is found' do
      result = described_class.search_by_name(clients, 'xyz')
      expect(result).to be_empty
    end
  end

  describe '.find_duplicates' do
    let(:clients) do
      [
        described_class.new({ 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' }),
        described_class.new({ 'id' => 2, 'full_name' => 'Alicia', 'email' => 'alice@example.com' }),
        described_class.new({ 'id' => 3, 'full_name' => 'Bob', 'email' => 'bob@example.com' })
      ]
    end

    it 'returns a hash of duplicate emails' do
      duplicates = described_class.find_duplicates(clients)
      expect(duplicates.keys).to include('alice@example.com')
      expect(duplicates['alice@example.com'].size).to eq(2)
    end

    it 'returns empty hash when there are no duplicates' do
      unique_clients = [
        described_class.new({ 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' }),
        described_class.new({ 'id' => 2, 'full_name' => 'Bob', 'email' => 'bob@example.com' }),
        described_class.new({ 'id' => 3, 'full_name' => 'Charlie', 'email' => 'charlie@example.com' })
      ]
      duplicates = described_class.find_duplicates(unique_clients)
      expect(duplicates).to be_empty
    end
  end
end
