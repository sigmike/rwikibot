
require File.join(File.dirname(__FILE__), "helper.rb")

class TestLogin < Test::Unit::TestCase
  def test_login_with_token
    bot = FakeRWikiBot.new 'my_name','my_pass','http://wiki.example.com/api.php'
    bot.expect_query "login",
      {"lgpassword" => "my_pass", "lgdomain" => "", "lgname" => "my_name"},
      {"result"=>"NeedToken", "token"=>"a token"}
    bot.expect_query "login",
      {"lgpassword" => "my_pass", "lgdomain" => "", "lgname" => "my_name", "lgtoken" => "a token"},
      {"result"=>"Success", "lguserid"=>"123456", "cookieprefix"=>"xxwiki", "lgusername"=>"my_name", "sessionid"=>"a_session_id", "lgtoken"=>"a token"}
    assert_equal true, bot.login
  end
end

