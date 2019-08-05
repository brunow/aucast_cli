require 'thor'
require 'yaml'
require 'aucast/file_upload'
require 'aucast/endpoint'
require 'aucast/youtube_dl'
require 'uri'

CONFIG_FILENAME = ".aucast.yml"

module Aucast
  class Cli < Thor
    
    def self.exit_on_failure?
      true
    end
    
    desc 'setup', 'Setup CLI'
    def setup
      yaml = {
      }
      
      server_address = ask("Type your Aucast bonjour webserver name (leave blank if you don't want to use it): ")
      
      if server_address.length > 0
        yaml["address"] = server_address
      end
      
      copy_to_path = ask("Type your inbox dir (leave blank if you doesn't want to use it): ", path: true)
      
      if copy_to_path.length > 0
        yaml["copy_to"] = copy_to_path
      end
      
      if yaml.count == 0
        say("Exit, nothing to write.")
        return
      end
      
      file_path = File.join(Dir.home, "/#{CONFIG_FILENAME}")
      File.write(file_path, yaml.to_yaml)
    end

    desc 'upload', 'Upload file(s) to Aucast'
    option :address, type: :string, aliases: "-a", desc: "phone ip address or bonjour service name to reach your phone"
    def upload(*args)
      args.each do |arg|
        if arg =~ URI::regexp
          youtube = YoutubeDl.new(arg)
          upload_file(youtube)
        else
          file = FileUpload.new(arg)
          upload_file(file)
        end
      end
    end
    
    desc 'copy', 'Copy file(s) to a specified path'
    option :destination, type: :string, aliases: "-d", desc: "the destination where to copy file"
    def copy(*args)
      destination_dir = options[:copy_to] || options[:destination]
      
      unless Dir.exist?(destination_dir)
        say("The dir used to copy file doesn't exist (#{destination_dir})", :red)
        return
      end
      
      args.each do |arg|
        if arg =~ URI::regexp
          youtube = YoutubeDl.new(arg)
          youtube.copy(destination_dir)
        else
          FileUtils.cp(arg, destination_dir)
        end
        
        say("Successfully copied #{arg}", :green)
      end
    end
    
    desc 'version', 'Print Rpush version'
    def version
      puts Aucast::VERSION
    end
    
    private
    
    def upload_file(uploadable)
      endpoint = Endpoint.new("http://#{options[:address]}")
      
      say("Uploading...")
      
      begin
        ret = uploadable.upload(endpoint)
      rescue => e
        say(e.message, :red)
        return
      end
      
      if ret
        say("Successfully uploaded #{uploadable.filename}", :green)
      else
        say(ret, :red)
      end
    end
    
    def options
      original_options = super
      config_path = File.join(Dir.home, "/#{CONFIG_FILENAME}")
      return original_options unless ::File.file?(config_path)
      defaults = ::YAML::load_file(config_path) || {}
      Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end
    
  end
end
