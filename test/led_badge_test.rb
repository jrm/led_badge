require 'test_helper'

class LedBadgeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::LedBadge::VERSION
  end

  def test_send_message
    badge = LedBadge::Badge.new
    badge.set_messages LedBadge::Feed.items("http://feeds.bbci.co.uk/news/rss.xml")
  end
    
end
