require 'test_helper'

class TestYoutubeDl < Aucast::Test

  def setup
    @youtube_dl = Aucast::YoutubeDl.new("https://www.youtube.com/watch?v=W01L70IGBgE")
    @tmpdir = Dir.mktmpdir
  end
  
  def teardown
    FileUtils.remove_entry_secure @tmpdir
  end
  
  def test_copy
    @youtube_dl.copy(@tmpdir)
    
    files_count = Dir
      .entries(@tmpdir)
      .select{ |e| File.file? "#{@tmpdir}/#{e}" }
      .count
      
    assert_equal(1, files_count)
  end
  
  def test_upload
    mock_endpoint = Minitest::Mock.new
    mock_endpoint.expect(:upload, nil, [String])
    
    @youtube_dl.upload(mock_endpoint)

    assert_mock mock_endpoint
  end
  
end