require "test_helper"

class MessagesMailboxTest < ActionMailbox::TestCase
  test "bounce mail for an unknown game" do
    inbound_email = receive_inbound_email_from_mail(
      to: '"unknown game" <123@mavrides.example>',
      from: '"Abelar" <bruce.s@mavrides.example>',
      subject: "Goodbye, Earth",
      body: "See you!"
    )

    assert inbound_email.bounced?
  end

  test "bounce mail for an ended game" do
    game = Game.create! status: :ended, explorer: characters(:abelar), earther: characters(:philip)
    inbound_email = receive_inbound_email_from_mail(
      to: "'finished game' <#{game.id}@mavrides.example>",
      from: '"Abelar" <bruce.s@mavrides.example>',
      subject: "Goodbye, Earth",
      body: "See you!"
    )

    assert inbound_email.bounced?
  end

  test "bounce mail for a game in which the sender doesn't participate" do
    game = games(:running_game)
    inbound_email = receive_inbound_email_from_mail(
      to: "#{game.id}@mavrides.example",
      from: '"Unknown player" <korolev@example.com>',
      subject: "White orbit",
      body: "Red star"
    )

    assert inbound_email.bounced?
  end
end
