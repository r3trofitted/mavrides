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

  test "#fill_hand adds 2 cards of the current event's type to the designated hand" do
    round = Round.new(game: games(:running_game)) do |r|
      r.earther_event  = Card.new(value: 1, suit: :clubs)
      r.explorer_event = Card.new(value: :ace, suit: :spades)

      # ensuring that the hands are empty to make the assertions simpler
      r.earther_hand  = []
      r.explorer_hand = []
    end

    round.fill_hand(:earther)
    assert_equal 2, round.earther_hand.count { |c| c.suit == :clubs }

    round.fill_hand(:explorer)
    assert_equal 2, round.explorer_hand.count { |c| c.suit == :spades }
  end

  test "serializing events" do
    event = Card.new value: :ace, suit: :spades
    round = Round.new game: games(:running_game), number: 3, earther_event: event

    assert_kind_of Card, round.earther_event
    assert round.save
  end

  test "serializing hands" do
    hand  = [Card.new(value: :ace, suit: :spades), Card.new(value: :king, suit: :clubs)]
    round = Round.new game: games(:running_game), number: 3, explorer_hand: hand

    assert_includes round.explorer_hand, Card.new(value: :ace, suit: :spades)
    assert_includes round.explorer_hand, Card.new(value: :king, suit: :clubs)
    assert round.save
  end
end
