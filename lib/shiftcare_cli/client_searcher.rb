module ShiftCareCLI
  class ClientSearcher
    def initialize(clients)
      @clients = clients
    end

    def search_by_name(query)
      query = query.downcase
      @clients.select do |client|
        client.full_name.downcase.include?(query)
      end
    end
  end
end
