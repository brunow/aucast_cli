require 'rest-client'

module Aucast
  # Endpoint for Aucast rest api
  class Endpoint
    
    # Class initializer
    # Params:
    # - endpoint_url: endpoint url without scheme (ex: work-iphone.local or 192.128.1.10)
    def initialize(endpoint_url)
      @endpoint_url = endpoint_url
    end
    
    # Upload a file
    # Params:
    # - file_path: ~/Documents/english_first_leson.mp3
    def upload(file_path)
      file = File.open(file_path, 'r')
      
      params = { "multipart" => true, "files[]" => file }
      response = RestClient.post "#{@endpoint_url}/upload", params

      case response.code
      when 400
        return { error: parse_json(response.to_str) }
      when 200
        return true
      else
        raise "Invalid response #{response.to_str} received."
      end
    end
  end
end
