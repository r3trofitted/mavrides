require "test_helper"

class MessagesMailerTest < ActionMailer::TestCase
  test "regular transmission" do
    mail = MessagesMailer
             .with(message: messages(:first_message))
             .transmission
    
    assert_equal "さようなら", mail.subject
    assert_equal ["#{games(:abelar_and_philip).id}@mavrides.example"], mail.from
    assert_equal ["vincent.o@mavrides.example"], mail.to
    
    body = mail.body.to_s.chomp # I'm not sure why chomp is needed, TBH, but here we are…
    
    # the Earther's Terrestrial Event is the 1st from the spades table (cf. abelar_and_philip_round_one fixtures)
    assert_match <<~GAME_EVENT_PROMPT.chomp, body
      The first successful demonstration of cryo-sleep technology on rodents raises the potential for human hibernation.
    GAME_EVENT_PROMPT
    
    # the Earther's Personal Event is "7" (cf. abelar_and_philip_round_one fixtures)
    assert_match <<~PERSONAL_EVENT_PROMPT.chomp, body
      Someone got married! Who was it and what do they mean to you?
    PERSONAL_EVENT_PROMPT
    
    assert_match <<~MESSAGE.chomp, body
      This is it. We are off. To Tau Ceti, can you believe it? Even though I'll never see what's out there, I know.
    MESSAGE
  end
  
  test "transmission when all five events from a Major Event table have come to pass" do
    message = messages(:second_to_last_message)
    mail    = MessagesMailer
                .with(message: message)
                .transmission
    
    assert_match <<~ENDING_NOTICE.squish, mail.body.to_s.chomp
      This event marks the end of the game. Send a final message to #{message.recipient_name}; this message will
      not be distorted. Finish the message with [Connection Lost].
    ENDING_NOTICE
  end
  
  test "message distortion" do
    message = Message.create! do |m|
      m.game    = games(:abelar_and_philip)
      m.round   = rounds(:abelar_and_philip_round_one)
      m.sender  = characters(:philip)
      m.subject = "Throwing rice!"
      m.content = "Big news, you will never believe it: my brother got married!"
    end
    
    mail = MessagesMailer.with(message: message).transmission
    
    assert_match <<~DISTORTED_MESSAGE.chomp, mail.body.to_s.chomp
      Kig news, you will never kelieve it: my krother got married!
    DISTORTED_MESSAGE
  end
end
