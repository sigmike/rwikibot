
require File.join(File.dirname(__FILE__), "helper.rb")

class TestContributions < Test::Unit::TestCase
  def test_contributions_method_should_make_correct_request
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob"},
      {"usercontribs"=>{"item"=>["foo"]}}
    bot.contributions("Bob")
  end

  def test_contributions_with_limit
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob", "uclimit" => "3"},
      {"usercontribs"=>{"item"=>["foo"]}}
    bot.contributions("Bob", 3)
  end
end

