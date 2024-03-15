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

    assert_match "The game has started. Reply to Abelar Lindsay with a message of congratulations", body
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

    refute_match "The game has started. Reply to Philip with a message of congratulations", body

    assert_match <<~LIGHTSPEED_LAG.squish, body
      It's been 14 days since you last wrote Abelar Lindsay.
    LIGHTSPEED_LAG

    # the Earther's Terrestrial Event is the 1st from the spades table (cf. running_game_round_two fixtures)
    assert_match <<~GAME_EVENT_PROMPT.squish, body
      In the meantime, the first successful demonstration of cryo-sleep technology on rodents raises the potential for human hibernation.
    GAME_EVENT_PROMPT

    # the Earther's Personal Event is "7" (cf. running_game_round_two fixtures)
    assert_match <<~PERSONAL_EVENT_PROMPT.squish, body
      As for yourself, someone got married! Who was it and what do they mean to you?
    PERSONAL_EVENT_PROMPT
  end

  test "transmission when all five events from a Major Event table have come to pass" do
    message = messages(:second_to_last_message)
    mail    = MessagesMailer
                .with(message: message)
                .transmission

    assert_match <<~ENDING_NOTICE.squish, mail.body.to_s.squish
      This event marks the end of the game. Send a final message to Abelar Lindsay; this message will
      not be distorted. Finish the message with [Connection Lost].
    ENDING_NOTICE
  end

  test "transmission when one player decides to end the game" do
    message = Message.create! do |m|
      m.game    = games(:running_game)
      m.round   = rounds(:running_game_round_two)
      m.sender  = characters(:philip_in_running_game) # PHilippe Constantine, played by Vincent O.
      m.subject = "This is it"
      m.content = <<~TXT
        I just don't feel like keeping writing to you. We've grown so far apart.

        [Connection Lost]
      TXT
    end

    mail = MessagesMailer.with(message: message).transmission

    assert_match <<~GAME_ENDED_NOTICE.squish, mail.body.to_s.squish
      Your connection with Philip Constantine has faded to the point that they no longer feel
      the drive to maintain it with you. Maybe you feel the same?

      This is the end of the game. Feel free to reach out to Vincent O. to debrief
      and discuss the feelings that it invoked.

      Thanks for playing!
    GAME_ENDED_NOTICE
  end

  test "message distortion" do
    message = Message.create! do |m|
      m.game    = games(:running_game)
      m.round   = rounds(:running_game_round_two)
      m.sender  = characters(:philip_in_running_game)
      m.subject = "Throwing rice!"
      m.content = "Big news, you will never believe it: my brother got married!"
    end

    mail = MessagesMailer.with(message: message).transmission

    assert_match <<~DISTORTED_MESSAGE.squish, mail.body.to_s.squish
      Kig news, you will never kelieve it: my krother got married!
    DISTORTED_MESSAGE
  end
end
