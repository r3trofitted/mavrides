require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "new card" do
    assert Card.new value: 3, suit: :spades
    
    assert_raises(ArgumentError) { assert Card.new value: 13, suit: :spades } # invalid value
    assert_raises(ArgumentError) { assert Card.new value: 3, suit: :cups }    # invalid suit
  end
  
  test "short string representation" do
    assert_equal "3♠️", Card.new(value: 3, suit: :spades).to_short_s
    assert_equal "A♥️", Card.new(value: :ace, suit: :hearts).to_short_s
    assert_equal "K♦️", Card.new(value: :king, suit: :diamonds).to_short_s
    assert_equal "8♣️", Card.new(value: 8, suit: :clubs).to_short_s
  end
end
