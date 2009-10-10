require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
$: << File.join(File.dirname(__FILE__), "..", "lib")
require 'rwikibot'

class FakeRWikiBot < RWikiBot
  def initialize(*args)
    @expected_queries = []
    super
  end
  
  def version
    "1.12"
  end
  
  def make_request(action, parameters)
    if @expected_queries.empty?
      raise "Invalid query. Expected no query but got #{action} with #{parameters.inspect}"
    end
    expected_action, expected_parameters, result = @expected_queries.shift
    if action != expected_action or parameters != expected_parameters
      raise "Invalid query. Expected #{expected_action} with #{expected_parameters.inspect} but got #{action} with #{parameters.inspect}"
    end
    result
  end
  
  def expect_query(action, parameters, result)
    @expected_queries << [action, parameters, result]
  end
end
