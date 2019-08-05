require 'minitest/autorun'
require 'aucast'
require "minitest/reporters"
require 'webmock/minitest'

Minitest::Reporters.use!
 
class Aucast::Test < MiniTest::Test
end