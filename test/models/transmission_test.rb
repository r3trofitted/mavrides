require "test_helper"

class TransmissionTest <  ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "for a transmission to the earther, the prompts are based on their event for the current round" do
    message = messages(:third_message_in_running_game)               # current round is :running_game_round_one
    transmission = Transmission.new message

    assert_equal :"earther.spades_1", transmission.game_event_prompt # 7♠️ is the 1st spades played to far
    assert_equal :"7", transmission.personal_event_prompt
  end

  test "for a transmission to the explorer, the prompts are based on their event for the next round" do
    message      = messages(:second_message_in_running_game)          # next round is :running_game_round_two
    transmission = Transmission.new message

    assert_equal :"explorer.hearts_1", transmission.game_event_prompt # A♥️ is the 1st hearts played so far
    assert_equal :"ace", transmission.personal_event_prompt
  end

  test "the distortion factors are relative to the message's round" do
    transmission = Transmission.new messages(:second_message_in_running_game)

    assert_equal 2, transmission.game.rounds.current.number # we're at the 2nd round…
    assert_empty transmission.distortion_factors            # … but the message relates to the 1st, where there is no distortion
  end
end
