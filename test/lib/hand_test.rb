require "test_helper"

class HandTest < ActiveSupport::TestCase
  test "serializing" do
    cards = [
      Card.new(value: :king, suit: :spades),
      Card.new(value: 5, suit: :spades),
      Card.new(value: 8, suit: :clubs),
      Card.new(value: 2, suit: :hearts),
      Card.new(value: :jack, suit: :diamonds)
    ]
    hand = Hand.new *cards
    
    # always by ascending suit, then value order (alphabetically)
    assert_equal "8♣️,J♦️,2♥️,5♠️,K♠️", Hand.dump(hand)
  end
  
  test "deserializing" do
    hand = Hand.load("8♣️,J♦️,2♥️,5♠️,K♠️")
    
    assert_includes hand, Card.new(value: :king, suit: :spades)
    assert_includes hand, Card.new(value: 5, suit: :spades)
    assert_includes hand, Card.new(value: 8, suit: :clubs)
    assert_includes hand, Card.new(value: 2, suit: :hearts)
    assert_includes hand, Card.new(value: :jack, suit: :diamonds)
  end
end
