require "test_helper"
require "action_mailbox/test_helper"

# TODO: DRY this and +ExampleOfPlayTest+
class StartingANewGameTest < ActionDispatch::IntegrationTest
  include ActionMailbox::TestHelper

  self.file_fixture_path += "/starting_a_new_game"

  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "setting up a new game" do
    receive_inbound_email_from_fixture "request_from_bruce.eml"

    emails = capture_emails do
      receive_inbound_email_from_fixture "request_from_vincent.eml"
    end

    assert emails.one? { |e| e.to == ["bruce.s@mavrides.example"] && e.subject = "A new game has started!" }
    assert emails.one? { |e| e.to == ["vincent.o@mavrides.example"] && e.subject = "A new game has started!" }
  end
end
