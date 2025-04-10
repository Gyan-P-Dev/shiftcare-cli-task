module ShiftCareCLI
  class DuplicateEmailChecker
    def initialize(clients)
      @clients = clients
    end

    def find_duplicates
      grouped = @clients.group_by(&:email)
      grouped.select { |_email, clients| clients.size > 1 }
    end
  end
end