require "test_helper"

class MessagesMailboxTest < ActionMailbox::TestCase
  test "bounce mail for an unknown game" do
    inbound_email = receive_inbound_email_from_mail(
      to: '"unknown game" <123@mavrides.example>',
      from: '"Abelar" <abelar@mavrides.example>',
      subject: "Goodbye, Earth"
    )

    assert inbound_email.bounced?
  end
  
  test "process mail for known games" do
    inbound_email = receive_inbound_email_from_mail(
    to: "#{games(:abelar_and_philip).id}@mavrides.example",
    from: '"Abelar" <abelar@mavrides.example>',
    subject: "Goodbye, Earth"
  )
  
  refute inbound_email.bounced?
  end
end
