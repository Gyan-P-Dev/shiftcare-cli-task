require_relative './fetch_client_data'
require_relative './client'
require 'json'
require 'open-uri'

module ShiftCareCLI
  class CLI
    CLIENTS_API_URL = 'https://appassets02.shiftcare.com/manual/clients.json'

    def self.run(args)
      command = args.first
      clients = fetch_clients if command != "help"

      case command
      when 'search'
        field = args[1]
        query = args[2..].join(' ').strip

        if field.nil? || query.empty?
          puts "Usage: search <field> <query>"
          puts "Available fields: full_name, email"
        else
          run_search(clients, field, query)
        end
      when 'duplicate_email'
        run_duplicate_email_check(clients)
      when nil
        puts "Total clients loaded: #{clients.size}"
      when 'help'
        print_help
      else
        puts "Unknown command: '#{command}'"
        print_help
      end
    end

    def self.fetch_clients
      puts "Fetching client data..."
      json_data = FetchClientData.fetch(CLIENTS_API_URL)
      json_data.map { |client_data| Client.new(client_data) }
    rescue => e
      puts "Failed to fetch clients: #{e.message}"
      exit(1)
    end

    def self.run_search(clients, field, query)
      results = Client.search_by(clients, field, query)

      if results.empty?
        puts "No clients found for #{field} matching '#{query}'."
      else
        puts "Found #{results.size} client(s):"
        results.each { |client| puts "#{client.full_name} (#{client.email})" }
      end
    end

    def self.run_duplicate_email_check(clients)
      duplicates = Client.find_duplicates(clients)

      if duplicates.empty?
        puts "No duplicate emails found."
      else
        puts "Duplicate emails found:"
        duplicates.each do |email, dup_clients|
          puts "#{email}:"
          dup_clients.each { |client| puts "#{client.full_name} (ID: #{client.id})" }
        end
      end
    end

    def self.print_help
      puts <<~HELP

        ShiftCare CLI - Available Commands:

        1. Search clients by field (email or full_name):
           bin/shiftcare_cli search <field> <query>
           Example: bin/shiftcare_cli search email john@example.com

        2. Find duplicate clients based on email:
           bin/shiftcare_cli duplicate_email

        3. Show this help menu:
           bin/shiftcare_cli help

      HELP
    end
  end
end
