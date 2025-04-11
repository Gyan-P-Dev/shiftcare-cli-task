module ShiftCareCLI
  class Client
    attr_reader :id, :full_name, :email

    def initialize(attrs = {})
      @id = attrs['id']
      @full_name = attrs['full_name']
      @email = attrs['email']&.downcase
    end

    def self.search_by(clients, field, query)
      field = field.to_sym
      query = query.downcase

      return [] if query.empty?

      unless [:full_name, :email].include?(field)
        puts "Invalid search field: #{field}"
        puts "Supported fields: full_name, email"
        return []
      end

      clients.select do |client|
        value = client.send(field)
        value && value.downcase.include?(query)
      end
    end

    def self.find_duplicates(clients)
      grouped = clients.select { |client| client.email.to_s.strip != '' }
                       .group_by { |client| client.email.downcase }
      grouped.select { |_email, group| group.size > 1 }
    end
  end
end
