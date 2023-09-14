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
  
  test "#fill_hand adds 2 cards of the current event's type to the designated hand" do
    skip "TODO: serialisation/deserialisation of hands and events for Rounds"
    
    round = Round.new(game: games(:abelar_and_philip)) do |r|
      r.earther_event  = Card.new(value: 1, suit: :clubs)
      r.explorer_event = Card.new(value: :ace, suit: :spades)
      
      # pretending that the hands are empty to make the assertions simpler
      r.earther_hand  = []
      r.explorer_hand = []
    end
    
    round.fill_hand(:earther)
    assert_equal 2, round.earther_hand.count { |c| c.suit == :clubs }
    
    round.fill_hand(:explorer)
    assert_equal 2, round.explorer_hand.count { |c| c.suit == :spades }
  end
end
