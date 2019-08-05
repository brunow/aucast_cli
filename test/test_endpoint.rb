require 'test_helper'

class TestEndpoint < Aucast::Test
  ENDPOINT_URL = "localhost:3000"

  def setup
    @endpoint = Aucast::Endpoint.new(ENDPOINT_URL)
  end
  
  def test_file_upload
    stub_request(:post, ENDPOINT_URL)
      .with(body: hash_including( {data: {multipart: true}} ))
      .to_return(body: "{}", status: 200)
      
    file_path = "test/testdata/audio.mp3"
    
    # Doesn't work yet
    # assert_equal @endpoint.upload(file_path), true
  end
  
end