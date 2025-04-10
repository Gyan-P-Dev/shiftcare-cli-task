require 'spec_helper'
require 'shiftcare_cli/client'
require 'shiftcare_cli/duplicate_email_checker'

RSpec.describe ShiftCareCLI::DuplicateEmailChecker do
  let(:duplicate_email) { 'john@example.com' }

  let(:clients_with_duplicates) do
    [
      ShiftCareCLI::Client.new({ 'id' => 1, 'full_name' => 'John Doe', 'email' => duplicate_email }),
      ShiftCareCLI::Client.new({ 'id' => 2, 'full_name' => 'Jane Doe', 'email' => 'jane@example.com' }),
      ShiftCareCLI::Client.new({ 'id' => 3, 'full_name' => 'Johnny Doe', 'email' => duplicate_email })
    ]
  end

  let(:clients_with_unique_emails) do
    [
      ShiftCareCLI::Client.new({ 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' }),
      ShiftCareCLI::Client.new({ 'id' => 2, 'full_name' => 'Jane Doe', 'email' => 'jane@example.com' }),
      ShiftCareCLI::Client.new({ 'id' => 3, 'full_name' => 'Johnny Doe', 'email' => 'johnny@example.com' })
    ]
  end

  describe '#find_duplicates' do
    context 'when duplicate emails exist' do
      it 'returns a hash with the duplicate email as the key' do
        checker = described_class.new(clients_with_duplicates)
        result = checker.find_duplicates

        expect(result).to be_a(Hash)
        expect(result.keys).to contain_exactly(duplicate_email)
        expect(result[duplicate_email].size).to eq(2)
      end
    end

    context 'when all emails are unique' do
      it 'returns an empty hash' do
        checker = described_class.new(clients_with_unique_emails)
        expect(checker.find_duplicates).to eq({})
      end
    end
  end
end
