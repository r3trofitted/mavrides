require "test_helper"

class MessagesMailerTest < ActionMailer::TestCase
  test "transmission" do
    mail = MessagesMailer
             .with(message: messages(:first_message))
             .transmission
    
    assert_equal "さようなら", mail.subject
    assert_equal ["bruce.s@mavrides.example"], mail.from
    assert_equal ["vincent.o@mavrides.example"], mail.to
    
    body = mail.body.to_s.chomp # I'm not sure why chomp is needed, TBH, but here we are…
    
    # the Earther's event prompt is the 1st from the spades table (cf. abelar_and_philip_round_one fixtures)
    assert_match <<~EVENT_PROMPT, body
    EVENT_PROMPT
      The first successful demonstration of cryo-sleep technology on rodents raises the potential for human hibernation.
    
    assert_match <<~MESSAGE, body
      This is it. We are off. To Tau Ceti, can you believe it? Even though I'll never see what's out there, I know.
    MESSAGE
  end
end
