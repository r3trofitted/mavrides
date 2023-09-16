require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "#recipient" do
    # the first message is sent by Abelar, so the recipient has to be Philip
    assert_equal messages(:first_message).recipient, characters(:philip)
  end
end
