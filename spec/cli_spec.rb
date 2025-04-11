require 'spec_helper'
require_relative '../lib/shiftcare_cli/cli'
require_relative '../lib/shiftcare_cli/client'

RSpec.describe ShiftCareCLI::CLI do
  let(:client1) { ShiftCareCLI::Client.new({ "id" => 1, "full_name" => "John Doe", "email" => "john@example.com" }) }
  let(:client2) { ShiftCareCLI::Client.new({ "id" => 2, "full_name" => "Jane Smith", "email" => "jane@example.com" }) }
  let(:client3) { ShiftCareCLI::Client.new({ "id" => 3, "full_name" => "Johnny Appleseed", "email" => "john@example.com" }) }

  before do
    allow(ShiftCareCLI::CLI).to receive(:fetch_clients).and_return([client1, client2, client3])
  end

  describe '.run' do
    context 'search command' do
      it 'prints matching clients for full_name' do
        expect {
          ShiftCareCLI::CLI.run(['search', 'full_name', 'john'])
        }.to output(/Found 2 client\(s\):.*John Doe.*Johnny Appleseed/m).to_stdout
      end

      it 'prints message for no matches' do
        expect {
          ShiftCareCLI::CLI.run(['search', 'full_name', 'nonexistent'])
        }.to output(/No clients found/).to_stdout
      end

      it 'prints usage message when query is missing' do
        expect {
          ShiftCareCLI::CLI.run(['search', 'full_name'])
        }.to output(/Usage: search <field> <query>/).to_stdout
      end
    end

    context 'when search command is missing arguments' do
      it 'prints usage instructions without error' do
        expect {
          described_class.run(['search'])
        }.to output(/Usage: search <field> <query>/).to_stdout
      end
    end

    context 'duplicate_email command' do
      it 'prints duplicate emails found' do
        expect {
          ShiftCareCLI::CLI.run(['duplicate_email'])
        }.to output(/Duplicate emails found:.*john@example.com/m).to_stdout
      end

      it 'prints message if no duplicates found' do
        allow(ShiftCareCLI::CLI).to receive(:fetch_clients).and_return([client1, client2])
        expect {
          ShiftCareCLI::CLI.run(['duplicate_email'])
        }.to output(/No duplicate emails found/).to_stdout
      end
    end

    context 'help command' do
      it 'prints help menu' do
        expect {
          ShiftCareCLI::CLI.run(['help'])
        }.to output(/ShiftCare CLI - Available Commands/).to_stdout
      end
    end

    context 'no command' do
      it 'prints total clients loaded' do
        expect {
          ShiftCareCLI::CLI.run([])
        }.to output(/Total clients loaded: 3/).to_stdout
      end
    end

    context 'unknown command' do
      it 'prints unknown command and help' do
        expect {
          ShiftCareCLI::CLI.run(['invalid'])
        }.to output(/Unknown command: 'invalid'.*Available Commands/m).to_stdout
      end
    end
  end
end
