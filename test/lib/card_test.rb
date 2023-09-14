require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "serializing" do
    assert_equal "3♠️", Card.dump(Card.new(value: 3, suit: :spades))
  end

  test "deserializing" do
    assert_equal Card.new(value: 3, suit: :spades), Card.load("3♠️")
  end

  test "short string representation" do
    assert_equal "3♠️", Card.new(value: 3, suit: :spades).to_short_s
    assert_equal "A♥️", Card.new(value: :ace, suit: :hearts).to_short_s
    assert_equal "K♦️", Card.new(value: :king, suit: :diamonds).to_short_s
    assert_equal "8♣️", Card.new(value: 8, suit: :clubs).to_short_s
  end

  test "providing a new hand" do
    hand = Card.new_hand

    assert_equal 4, hand.count
    assert_equal 4, hand.map(&:suit).uniq.count # 1 card of each suit
  end
end
