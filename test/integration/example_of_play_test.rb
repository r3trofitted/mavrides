require "test_helper"
require "action_mailbox/test_helper"

# Stubbing the picking of event cards from the player's hands
module RoundStubs
  EARTHER_HAND  = Hand.load("10♣️,2♥️,J♦️").to_enum
  EXPLORER_HAND = Hand.load("7♠️,9♣️,A♥️,5♦️").to_enum

  class << self
    @on = false

    def on?
      @on
    end

    def turn_on
      @on = true
    end

    # Because once included, the module cannot be removed, we need to be able to turn it off for the rest of the suite
    def turn_off
      @on = false
    end
  end

  def explorer_hand
    if RoundStubs.on? && caller_locations.first.label == "next"
      [EXPLORER_HAND.next]
    else
      super
    end
  end

  def earther_hand
    if RoundStubs.on? && caller_locations.first.label == "next"
      [EARTHER_HAND.next]
    else
      super
    end
  end
end

class ExampleOfPlayTest < ActionDispatch::IntegrationTest
  include ActionMailbox::TestHelper

  self.file_fixture_path += "/example_of_play"

  setup do
    ActionMailer::Base.deliveries.clear

    @game = Game.new id: 20090925,
                     earther: characters(:philip_in_starting_game),
                     explorer: characters(:abelar_in_starting_game)

    Round.include RoundStubs
    RoundStubs.turn_on
  end

  teardown do
    RoundStubs.turn_off
  end

  # This is an exceptionally short game, ending at the 2nd round
  test "example of play" do
    emails = capture_emails { @game.starts! }

    # Explorer receives instructions
    explorer_instructions = emails.find { |e| e.to == ["bruce.s@mavrides.example"] }

    assert_equal ["20090925@mavrides.example"], explorer_instructions.from
    assert_equal "A new game has started!", explorer_instructions.subject
    # Mail adds \r to line endings (see +Mail::Utilities.to_lf+), but our fixtures don't have them, so some squishing is necessary
    # TODO: create a helper to compare mail bodies with fixtures
    assert_equal file_fixture("explorer_instructions.text").read.squish, explorer_instructions.body.to_s.squish

    # Earther receives instructions
    earther_instructions = emails.find { |e| e.to == ["vincent.o@mavrides.example"] }

    assert_equal ["20090925@mavrides.example"], earther_instructions.from
    assert_equal "A new game has started!", earther_instructions.subject
    assert_equal file_fixture("earther_instructions.text").read.squish, earther_instructions.body.to_s.squish

    # Explorer sends their first message, Earther receives it
    emails = capture_emails do
      receive_inbound_email_from_fixture "from_explorer_round_1.eml"
    end
    message = emails.first

    assert_equal ["20090925@mavrides.example"], message.from
    assert_equal ["vincent.o@mavrides.example"], message.to
    assert_equal "Off I go!", message.subject
    assert_equal file_fixture("transmission_from_explorer_round_1.txt").read.squish, message.body.to_s.squish

    # Earther replies with their first message, Explorer receives it
    emails = capture_emails do
      receive_inbound_email_from_fixture "from_earther_round_1.eml"
    end
    message = emails.first

    assert_equal ["20090925@mavrides.example"], message.from
    assert_equal ["bruce.s@mavrides.example"], message.to
    assert_equal "Wish you a safe journey", message.subject
    assert_equal file_fixture("transmission_from_earther_round_1.txt").read.squish, message.body.to_s.squish
    # Round 1 finishes

    # Explorer sends their 2nd message, Earther receives it
    emails = capture_emails do
      receive_inbound_email_from_fixture "from_explorer_round_2.eml"
    end
    message = emails.first

    assert_equal ["20090925@mavrides.example"], message.from
    assert_equal ["vincent.o@mavrides.example"], message.to
    assert_equal "I'm still here", message.subject
    # Distortion in the transmission: 7 (B->K)
    assert_equal file_fixture("transmission_from_explorer_round_2.txt").read.squish, message.body.to_s.squish

    # Earther replies with their 2nd and final message, Explorer receives it
    emails = capture_emails do
      receive_inbound_email_from_fixture "from_earther_round_2.eml"
    end
    message = emails.first

    assert_equal ["20090925@mavrides.example"], message.from
    assert_equal ["bruce.s@mavrides.example"], message.to
    assert_equal "Signing off", message.subject
    assert_equal file_fixture("transmission_from_earther_round_2.txt").read.squish, message.body.to_s.squish

    # Game finishes
  end

  private

  # Stolen from ActionMailer::TestCase
  def read_fixture(filename)
    IO.readlines File.join(Rails.root, "test", "fixtures", filename)
  end
end
