require 'shiftcare_cli/client'

RSpec.describe ShiftCareCLI::Client do
  let(:attrs) { { 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' } }

  it 'initializes with correct attributes' do
    client = described_class.new(attrs)
    expect(client.id).to eq(1)
    expect(client.full_name).to eq('Alice')
    expect(client.email).to eq('alice@example.com')
  end
end