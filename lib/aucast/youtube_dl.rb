require 'aucast/file_upload'

module Aucast
  
  class YoutubeDl
    def initialize(url)
      @url = url
    end
    
    def filename
      @url
    end
    
    def copy(destination)
      tmpdir = Dir.mktmpdir
      
      begin
        download_video(@url, tmpdir)
        file_path = find_audio_in_tmpdir(tmpdir)
        FileUtils.cp(file_path, destination)
      ensure
        FileUtils.remove_entry_secure tmpdir
      end
    end
    
    def upload(endpoint)
      tmpdir = Dir.mktmpdir
      
      begin
        download_video(@url, tmpdir)
        file_path = find_audio_in_tmpdir(tmpdir)
        file_uploader = FileUpload.new(file_path)
        file_uploader.upload(endpoint)
      ensure
        FileUtils.remove_entry_secure tmpdir
      end
    end
    
    protected
    
    def find_audio_in_tmpdir(tmpdir)
      Dir
        .entries(tmpdir)
        .map { |f| File.join(tmpdir, f) }
        .select { |f| File.file?(f) }
        .first
    end
    
    def download_video(url, outdir)
      system <<-SH
            cd #{outdir} && \
            youtube-dl \
                --extract-audio \
                --restrict-filenames \
                --audio-format mp3 \
                --audio-quality 0 \
                --add-metadata \
                --embed-thumbnail \
                --output "%(uploader)s %(title)s.%(ext)s" \
              #{url}
          SH
    end
    
  end
end