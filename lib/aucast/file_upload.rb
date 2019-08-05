require 'aucast/endpoint'

module Aucast
  # Upload a file to Aucast webservice
  class FileUpload
    def initialize(file_path)
      @file_path = file_path
    end
    
    def filename
      @file_path.split("/").last
    end
    
    def upload(endpoint)
      ret = endpoint.upload(@file_path)
      
      if ret
        true
      elsif ret.is_a? Hash and ret[:error]
        ret[:error]
      elsif ret.is_a? String
        ret
      else
        nil
      end
    end
    
  end
end