require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "a hand is drawn when the first round is created" do
    round = Round.new number: 1
    
    refute_empty round.earther_hand
    refute_empty round.explorer_hand
  end
end
