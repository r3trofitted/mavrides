require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "short string representation" do
    assert_equal "3♠️", Card.new(value: 3, suit: Card::SPADES).to_short_s
    assert_equal "K♦️", Card.new(value: Card::KING, suit: Card::DIAMONDS).to_short_s
    assert_equal "A♥️", Card.new(value: :ace, suit: :hearts).to_short_s            # alternative notation
    assert_equal "8♣️", Card.new(value: "8", suit: :clubs).to_short_s
  end
end
