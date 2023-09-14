require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "a hand is drawn when the first round is created" do
    round = Round.new number: 1

    assert_not_empty round.earther_hand
    assert_not_empty round.explorer_hand
  end

  test "#next builds a new Round" do
    new_round = rounds(:running_game_round_one).next

    assert_equal rounds(:running_game_round_one).game, new_round.game
    assert_equal 2, new_round.number
    assert_nil new_round.earther_event
    assert_nil new_round.explorer_event
    assert_not_nil new_round.earther_hand
    assert_not_nil new_round.explorer_hand
  end
end
