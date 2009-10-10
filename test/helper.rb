require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
$: << File.join(File.dirname(__FILE__), "..", "lib")
require 'rwikibot'

class FakeRWikiBot < RWikiBot
  attr_accessor :requests
  
  def initialize(*args)
    @requests = []
    super
  end
  
  def version
    "1.12"
  end
  
  def make_request(action, parameters)
    @requests << [action, parameters]
  end
end
