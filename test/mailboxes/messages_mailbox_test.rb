require "test_helper"

class MessagesMailboxTest < ActionMailbox::TestCase
  include ActionMailer::TestHelper

  setup do
    ActionMailer::Base.deliveries.clear

    @game = games(:starting_game)
  end

  test "bounce mail for an unknown game" do
    inbound_email = receive_inbound_email_from_mail(
      to: '"unknown game" <123@mavrides.example>',
      from: '"Abelar" <bruce.s@mavrides.example>',
      subject: "Goodbye, Earth",
      body: "See you!"
    )

    assert inbound_email.bounced?
  end

  test "bounce mail for ended games" do
    game = games(:ending_game)
    game.ended!

    inbound_email = receive_inbound_email_from_mail(
      to: "'finished game' <#{game.id}@mavrides.example>",
      from: '"Abelar" <bruce.s@mavrides.example>',
      subject: "Goodbye, Earth",
      body: "See you!"
    )

    assert inbound_email.bounced?
  end

  test "bounce mail for a game in which the sender doesn't participate" do
    inbound_email = receive_inbound_email_from_mail(
      to: "#{@game.id}@mavrides.example",
      from: '"Unknown player" <korolev@example.com>',
      subject: "White orbit",
      body: "Red star"
    )

    assert inbound_email.bounced?
  end

  test "creates a new message from the mail" do
    assert_difference -> { @game.messages.count } do
      receive_inbound_email_from_fixture "second_message.eml"
    end
  end

  test "bounces if the new message cannot be created" do
    inbound_email = receive_inbound_email_from_fixture "empty_message.eml"

    assert inbound_email.bounced?
  end
end
