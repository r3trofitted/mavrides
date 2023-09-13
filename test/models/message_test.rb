require "test_helper"

class MessageTest < ActiveSupport::TestCase
  fixtures :all
  
  test "#recipient" do
    # the first message is sent by Abelar, so the recipient has to be Philip
    assert_equal messages(:first_message).recipient, players(:philip)
  end
end
