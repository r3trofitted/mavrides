require "test_helper"

class MessagesMailerTest < ActionMailer::TestCase
  test "transmission" do
    mail = MessagesMailer
             .with(message: messages(:first_message))
             .transmission(rounds(:abelar_and_philip_round_one))
    
    assert_equal "さようなら", mail.subject
    assert_equal ["bruce.s@mavrides.example"], mail.from
    assert_equal ["vincent.o@mavrides.example"], mail.to
    
    body = mail.body.to_s.chomp # I'm not sure why chomp is needed, TBH, but here we are…
    
    # the Earther's event prompt is the 1st from the spades table (cf. abelar_and_philip_round_one fixtures)
    assert_match <<~EVENT_PROMPT, body
      Observatory stations detect an anomaly consistent with states of matter previously confined to theoretical equations.
    EVENT_PROMPT
    
    assert_match <<~MESSAGE, body
      This is it. We are off. To Tau Ceti, can you believe it? Even though I'll never see what's out there, I know.
    MESSAGE
  end
end
