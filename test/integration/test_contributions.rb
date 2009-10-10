
require File.join(File.dirname(__FILE__), "..", "helper.rb")

LOGIN = "IntegrationTest"
PASSWORD = "Di8re0ie"

class TestIntegrationContributions < Test::Unit::TestCase
  def test_piglobot_contributions
    bot = RWikiBot.new LOGIN, PASSWORD, 'http://fr.wikipedia.org/w/api.php'
    contributions = bot.contributions("Piglobot", 5)
    assert_equal 5, contributions.size, contributions.inspect
  end
end
