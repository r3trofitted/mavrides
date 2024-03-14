require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test ".build_first builds the first round for a given game, with no events drawn and basic hands" do
    round = Round.build_first game: games(:starting_game)

    assert_equal 1, round.number
    assert_nil round.earther_event
    assert_nil round.explorer_event
    assert_equal 4, round.earther_hand.count
    assert_equal 4, round.explorer_hand.count
  end

  test "#next builds a new Round with 1 event drawn and 2 cards added to each hand for each player" do
    round = Round.new do |r|
      r.game           = games(:starting_game)
      r.number         = 2
      r.earther_event  = nil # unnecessary here
      r.explorer_event = nil # unnecessary here
      r.earther_hand   = [Card.new(value: 2, suit: :clubs)]     # fixing the hand to stub the event draw and simplify the testing of 2 cards being added
      r.explorer_hand  = [Card.new(value: :ace, suit: :spades)] # fixing the hand to stub the event draw and simplify the testing of 2 cards being added
    end

    new_round = round.next

    assert_equal rounds(:starting_game_round_one).game, new_round.game
    assert_equal 3, new_round.number
    assert_equal Card.new(value: 2, suit: :clubs), new_round.earther_event      # only card in the earther's hand
    assert_equal Card.new(value: :ace, suit: :spades), new_round.explorer_event # only card in the explorer's hand
    assert_equal 2, new_round.earther_hand.count { |c| c.suit == :clubs }       # same suit as the event; 2 cards because 1 has been draws and 2 added
    assert_equal 2, new_round.explorer_hand.count { |c| c.suit == :spades }     # same suit as the event; 2 cards because 1 has been draws and 2 added
  end

  test "serializing events" do
    event = Card.new value: :ace, suit: :spades
    round = Round.new game: games(:starting_game), number: 3, earther_event: event

    assert_kind_of Card, round.earther_event
    assert round.save
  end

  test "serializing hands" do
    hand  = [Card.new(value: :ace, suit: :spades), Card.new(value: :king, suit: :clubs)]
    round = Round.new game: games(:starting_game), number: 3, explorer_hand: hand

    assert_includes round.explorer_hand, Card.new(value: :ace, suit: :spades)
    assert_includes round.explorer_hand, Card.new(value: :king, suit: :clubs)
    assert round.save
  end

  test "returning the event for a given Player" do
    round    = rounds(:running_game_round_two)
    earther  = characters(:philip_in_running_game)
    explorer = characters(:abelar_in_running_game)

    assert_equal Card.new(value: 7, suit: :spades), round.event_for(earther)
    assert_equal Card.new(value: :ace, suit: :hearts), round.event_for(explorer)
  end

  test "returning the hand for a given Player" do
    round    = rounds(:running_game_round_two)
    earther  = characters(:philip_in_running_game)
    explorer = characters(:abelar_in_running_game)

    # Using the dumped values for ease here
    assert_equal "8♣️,J♦️,2♥️,5♠️,K♠️", Hand.dump(round.hand_of(earther))
    assert_equal "9♣️,5♦️,5♥️,Q♥️,7♠️", Hand.dump(round.hand_of(explorer))
  end
end
