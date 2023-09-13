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
end
