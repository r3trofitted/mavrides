require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "a hand is drawn when the first round is created" do
    round = Round.new number: 1
    
    refute_empty round.earther_hand
    refute_empty round.explorer_hand
  end
  
  test "#next builds a new Round with 2 cards added to each hand" do
    round = Round.new do |r|
      r.game           = games(:abelar_and_philip)
      r.number         = 2
      r.earther_event  = Card.new(value: 1, suit: :clubs)
      r.explorer_event = Card.new(value: :ace, suit: :spades)
      r.earther_hand   = [] # ensuring that the hands are empty to make the assertions simpler
      r.explorer_hand  = [] # ensuring that the hands are empty to make the assertions simpler
    end
    
    new_round = round.next
    
    assert_equal rounds(:abelar_and_philip_round_one).game, new_round.game
    assert_equal 3, new_round.number
    assert_nil new_round.earther_event
    assert_nil new_round.explorer_event
    assert_equal 2, new_round.earther_hand.count { |c| c.suit == :clubs }   # same suit as the event
    assert_equal 2, new_round.explorer_hand.count { |c| c.suit == :spades } # same suit as the event
  end
  
  test "serializing events" do
    event = Card.new value: :ace, suit: :spades
    round = Round.new game: games(:abelar_and_philip), number: 3, earther_event: event
    
    assert_kind_of Card, round.earther_event
    assert round.save
  end
  
  test "serializing hands" do
    hand  = [Card.new(value: :ace, suit: :spades), Card.new(value: :king, suit: :clubs)]
    round = Round.new game: games(:abelar_and_philip), number: 3, explorer_hand: hand
    
    assert_includes round.explorer_hand, Card.new(value: :ace, suit: :spades)
    assert_includes round.explorer_hand, Card.new(value: :king, suit: :clubs)
    assert round.save
  end
end
