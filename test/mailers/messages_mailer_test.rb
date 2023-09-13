require "test_helper"

class MessagesMailerTest < ActionMailer::TestCase
  test "transmission" do
    mail = MessagesMailer.with(message: messages(:first_message)).transmission
    
    assert_equal "さようなら", mail.subject
    assert_equal ["abelar@mavrides.example"], mail.from
    assert_equal ["philip@mavrides.example"], mail.to
    
    assert_equal <<~TXT, mail.text_part.body.to_s.chomp # I'm not sure why chomp is needed, TBH, but here we are…
      This is it. We are off. To Tau Ceti, can you believe it? Even though I'll never see what's out there, I know.
    TXT
  end
end
