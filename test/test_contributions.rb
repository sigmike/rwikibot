
require File.join(File.dirname(__FILE__), "helper.rb")

class TestContributions < Test::Unit::TestCase
  def test_contributions_method_with_only_user
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob"},
      {"usercontribs"=>{"item"=>["foo"]}}
    assert_equal ["foo"], bot.contributions(:user => "Bob")
  end

  def test_contributions_method_with_user_and_limit
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob", "uclimit" => "3"},
      {"usercontribs"=>{"item"=>["foo"]}}
    assert_equal ["foo"], bot.contributions(:user => "Bob", :limit => 3)
  end

  def test_contributions_method_with_only_one_result
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob", "uclimit" => "3"},
      {"usercontribs"=>{"item"=>{"foo" => "bar"}}}
    assert_equal [{"foo" => "bar"}], bot.contributions(:user => "Bob", :limit => 3)
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
end

