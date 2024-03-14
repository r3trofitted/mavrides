require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "#recipient" do
    # the first message is sent by Abelar, so the recipient has to be Philip
    assert_equal messages(:first_message).recipient, characters(:philip_in_starting_game)
  end

  test "#final?" do
    message_with_ending_sequence = Message.new content: "This is it.\n[Connection Lost]"
    assert message_with_ending_sequence.final?

    message_with_ending_sequence_alt_case = Message.new content: "This is it.\n[CONNECTION LOST]"
    assert message_with_ending_sequence.final?

    message_without_ending_sequence = Message.new content: "This is it.\n"
    refute message_without_ending_sequence.final?
  end
end
