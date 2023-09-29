require "test_helper"

class TransmissionTest <  ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "the distortion factors are relative to the message's round" do
    transmission = Transmission.new messages(:second_message_in_running_game)

    assert_equal 2, transmission.game.rounds.current.number # we're at the 2nd round…
    assert_empty transmission.distortion_factors            # … but the message relates to the 1st, where there is no distortion
  end
end
