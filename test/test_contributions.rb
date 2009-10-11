
require File.join(File.dirname(__FILE__), "helper.rb")

class TestContributions < Test::Unit::TestCase
  def test_contributions_method_with_only_user
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob"},
      {"usercontribs"=>{"item"=>["foo"]}}
    assert_equal ["foo"], bot.contributions(:user => "Bob")
  end

  def test_contributions_with_all_parameters
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    parameters = %w(
      user
      userprefix
      start
      end
      continue
      dir
      limit
      namespace
      show
      prop
    )
    expected_parameters = [["list", "usercontribs"]] + parameters.map { |param| ["uc" + param, param] }
    expected_parameters = Hash[*expected_parameters.flatten]
    
    # Test with symbols, strings and "uc" form
    [
      proc { |param| param.intern },
      proc { |param| param },
      proc { |param| "uc" + param },
      proc { |param| ("uc" + param).intern },
    ].each do |block|
      hash_parameters = parameters.map { |param| [block.call(param), param] }
      hash_parameters = Hash[*hash_parameters.flatten]
      bot.expect_query "query",
        expected_parameters,
        {"usercontribs"=>{"item"=>["foo"]}}
      assert_equal ["foo"], bot.contributions(hash_parameters)
    end
  end
  
  def test_contributions_without_result
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      :any,
      {"usercontribs"=>{}}
    assert_equal [], bot.contributions(:user => "Bob")
  end
  
  def test_contributions_timestamp_is_converted_to_datetime
    item = {
      "comment"=>"test 2",
      "size"=>"0",
      "revid"=>"45649269",
      "pageid"=>"2074026",
      "timestamp"=>"2009-10-11T05:30:35Z",
      "title"=>"Utilisateur:Piglobot/Bac \303\240 sable",
      "ns"=>"2",
      "user"=>"Piglobot",
      "top"=>""
    }

    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      :any,
      {"usercontribs"=>{"item" => [item]}}
    result = bot.contributions(:user => "Bob").first
    assert_equal DateTime.new(2009, 10, 11, 5, 30, 35, 0), result["timestamp"]
  end
end

