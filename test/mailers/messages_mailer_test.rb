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
    
    # the Earther's Terrestrial Event is the 1st from the spades table (cf. abelar_and_philip_round_one fixtures)
    assert_match <<~GAME_EVENT_PROMPT.chomp, body
      The first successful demonstration of cryo-sleep technology on rodents raises the potential for human hibernation.
    GAME_EVENT_PROMPT
    
    # the Earther's Personal Event is "3" (cf. abelar_and_philip_round_one fixtures)
    assert_match <<~PERSONAL_EVENT_PROMPT.chomp, body
      A major holiday brings back memories of an event you’d forgotten about.
    PERSONAL_EVENT_PROMPT
    
    assert_match <<~MESSAGE.chomp, body
      This is it. We are off. To Tau Ceti, can you believe it? Even though I'll never see what's out there, I know.
    MESSAGE
  end
end
