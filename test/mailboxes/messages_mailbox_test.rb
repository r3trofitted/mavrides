require "test_helper"

class MessagesMailboxTest < ActionMailbox::TestCase
  include ActionMailer::TestHelper
  
  fixtures :games, :players
  
  setup do
    ActionMailer::Base.deliveries.clear
    
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
    
  test "transmit message to the other player" do
    assert_difference -> { @game.messages.count } do
      receive_inbound_email_from_fixture "first_message.eml"
    end
    
    assert_enqueued_email_with MessagesMailer, :transmission, params: { message: Message.last }
  end
end
