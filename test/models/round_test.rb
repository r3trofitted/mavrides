require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "a hand is drawn when the first round is created" do
    round = Round.new number: 1

    assert_not_empty round.earther_hand
    assert_not_empty round.explorer_hand
  end
end
