
require File.join(File.dirname(__FILE__), "helper.rb")

class TestRevisions < Test::Unit::TestCase
  def test_revisions_of_single_page
    bot = FakeRWikiBot.new 'botuser','botpass','http://wiki.example.com/api.php'
    bot.expect_query "query",
      {"prop" => "revisions", "titles" => "Bob", "rvprops" => "ids|timestamp|user", "rvlimit" => "3"},
      nil
    assert_equal nil, bot.revisions(:titles => "Bob", :limit => 3, :props => %w( ids timestamp user ))
  end
end

