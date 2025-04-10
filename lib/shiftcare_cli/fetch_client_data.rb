require 'json'
require 'uri'
require 'net/http'

module ShiftCareCLI
  class FetchClientData
    def self.fetch(url)
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)

      unless response.is_a?(Net::HTTPSuccess)
        raise "HTTP request failed with code #{response.code}"
      end

      begin
        JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise "Failed to parse JSON: #{e.message}"
      end
    end
  end
end