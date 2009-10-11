
require File.join(File.dirname(__FILE__), "helper.rb")

class TestContributions < Test::Unit::TestCase
  def test_contributions_method_with_only_user
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"list" => "usercontribs", "ucuser" => "Bob"},
      {"usercontribs"=>{"item"=>["foo"]}}
    bot.contributions(:user => "Bob")
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
    
    parameters = parameters.map { |param| [param.intern, param] }
    parameters = Hash[*parameters.flatten]
    bot.expect_query "query",
      expected_parameters,
      {"usercontribs"=>{"item"=>["foo"]}}
    bot.contributions(parameters)
  end
end

