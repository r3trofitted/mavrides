require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "a hand is drawn when the first round is created" do
    round = Round.new number: 1
    
    refute_empty round.earther_hand
    refute_empty round.explorer_hand
  end
  
  test "#next builds a new Round" do
    new_round = rounds(:abelar_and_philip_round_one).next
    
    assert_equal rounds(:abelar_and_philip_round_one).game, new_round.game
    assert_equal 2, new_round.number
    assert_nil new_round.earther_event
    assert_nil new_round.explorer_event
    refute_nil new_round.earther_hand
    refute_nil new_round.explorer_hand
  end
end
