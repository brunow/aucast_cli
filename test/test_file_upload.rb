require 'test_helper'

class TestFileUpload < Aucast::Test

  def test_upload_call_endpoint
    file_path = "test/sample/audio.mp3"

    mock_endpoint = Minitest::Mock.new
    mock_endpoint.expect(:upload, nil, [file_path])
    
    file = Aucast::FileUpload.new(file_path)
    file.upload(mock_endpoint)

    assert_mock mock_endpoint
  end
  
end