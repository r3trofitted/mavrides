require "test_helper"

class GamesMailboxTest < ActionMailbox::TestCase
  include ActionMailer::TestHelper

  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "records a pending game from the mail" do
    assert_difference -> { Game.pending.count } do
      receive_inbound_email_from_fixture "new_game_creation.eml"
    end
  end
end
