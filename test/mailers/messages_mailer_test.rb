require "test_helper"

class MessagesMailerTest < ActionMailer::TestCase
  test "transmission during the first round" do
    mail = MessagesMailer
             .with(message: messages(:first_message))
             .transmission
    
    assert_equal "さようなら", mail.subject
    assert_equal ["#{games(:starting_game).id}@mavrides.example"], mail.from
    assert_equal ["vincent.o@mavrides.example"], mail.to
    
    body = mail.body.to_s.squish
    
    assert_match <<~MESSAGE.squish, body
      This is it. We are off. To Tau Ceti, can you believe it? Even though I'll never see what's out there, I know.
    MESSAGE
    
    refute_match "Since your last message, the following events occured:", body
  end
  
  test "regular transmission after the first round" do
    mail = MessagesMailer
             .with(message: messages(:third_message_in_running_game))
             .transmission
    
    assert_equal "You'll never guess what happened", mail.subject
    assert_equal ["#{games(:running_game).id}@mavrides.example"], mail.from
    assert_equal ["vincent.o@mavrides.example"], mail.to
    
    body = mail.body.to_s.squish
    
    assert_match <<~MESSAGE.squish, body
      … Or maybe you will. You tell me!
    MESSAGE

    assert_match "Since your last message, the following events occured:", body
    
    # the Earther's Terrestrial Event is the 1st from the spades table (cf. running_game_round_two fixtures)
    assert_match <<~GAME_EVENT_PROMPT.squish, body
      The first successful demonstration of cryo-sleep technology on rodents raises the potential for human hibernation.
    GAME_EVENT_PROMPT
    
    # the Earther's Personal Event is "7" (cf. running_game_round_two fixtures)
    assert_match <<~PERSONAL_EVENT_PROMPT.squish, body
      Someone got married! Who was it and what do they mean to you?
    PERSONAL_EVENT_PROMPT
  end
  
  test "transmission when all five events from a Major Event table have come to pass" do
    message = messages(:second_to_last_message)
    mail    = MessagesMailer
                .with(message: message)
                .transmission
    
    assert_match <<~ENDING_NOTICE.squish, mail.body.to_s.squish
      This event marks the end of the game. Send a final message to #{message.recipient_name}; this message will
      not be distorted. Finish the message with [Connection Lost].
    ENDING_NOTICE
  end
  
  test "message distortion" do
    message = Message.create! do |m|
      m.game    = games(:running_game)
      m.round   = rounds(:running_game_round_two)
      m.sender  = characters(:philip)
      m.subject = "Throwing rice!"
      m.content = "Big news, you will never believe it: my brother got married!"
    end
    
    mail = MessagesMailer.with(message: message).transmission
    
    assert_match <<~DISTORTED_MESSAGE.squish, mail.body.to_s.squish
      Kig news, you will never kelieve it: my krother got married!
    DISTORTED_MESSAGE
  end
end
