require "test_helper"

class MessagesMailboxTest < ActionMailbox::TestCase
  setup do
    @game = games(:abelar_and_philip)
  end
  
  test "bounce mail for an unknown game" do
    inbound_email = receive_inbound_email_from_mail(
      to: '"unknown game" <123@mavrides.example>',
      from: '"Abelar" <abelar@mavrides.example>',
      subject: "Goodbye, Earth"
    )
    
    assert inbound_email.bounced?
  end
  
  test "bounce mail for a game in which the sender doesn't participate" do
    inbound_email = receive_inbound_email_from_mail(
      to: "#{@game.id}@mavrides.example",
      from: '"Unknown player" <korolev@example.com>',
      subject: "White orbit"
    )
    
    assert inbound_email.bounced?
  end
    
  test "process mail for known games" do
    inbound_email = receive_inbound_email_from_mail(
      to: "#{@game.id}@mavrides.example",
      from: '"Abelar" <abelar@mavrides.example>',
      subject: "Goodbye, Earth"
    )
    
    refute inbound_email.bounced?
  end
end
