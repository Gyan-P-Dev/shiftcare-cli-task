module ShiftCareCLI
  class Client
    attr_reader :id, :full_name, :email

    def initialize(attrs = {})
      @id = attrs['id']
      @full_name = attrs['full_name']
      @email = attrs['email']
    end

    def self.search_by_name(clients, query)
      query = query.downcase
      clients.select do |client|
        client.full_name.downcase.include?(query)
      end
    end

    def self.find_duplicates(clients)
      grouped = clients.group_by(&:email)
      grouped.select { |_email, group| group.size > 1 }
    end
  end
end
