require 'spec_helper'
require 'shiftcare_cli/client'
require 'shiftcare_cli/client_searcher'

RSpec.describe ShiftCareCLI::ClientSearcher do
  let(:clients) do
    [
      ShiftCareCLI::Client.new({ "id" => 1, "full_name" => "John Doe", "email" => "john@example.com" }),
      ShiftCareCLI::Client.new({ "id" => 2, "full_name" => "Jane Smith", "email" => "jane@example.com" }),
      ShiftCareCLI::Client.new({ "id" => 3, "full_name" => "Johnny Appleseed", "email" => "johnny@apple.com" })
    ]
  end

  subject(:searcher) { described_class.new(clients) }

  describe '#search_by_name' do
    it 'returns clients matching the name (case-insensitive)' do
      result = searcher.search_by_name('john')
      expect(result.map(&:full_name)).to contain_exactly("John Doe", "Johnny Appleseed")
    end

    it 'returns empty array when no matches found' do
      result = searcher.search_by_name('doesnotexist')
      expect(result).to be_empty
    end

    it 'returns full match if exact name is provided' do
      result = searcher.search_by_name('jane smith')
      expect(result.map(&:full_name)).to contain_exactly("Jane Smith")
    end
  end
end
