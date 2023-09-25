require "test_helper"

class GameMailerTest < ActionMailer::TestCase
  setup do
    @mailer = GameMailer.with game: games(:starting_game)
  end
  
  test "game_starts_for_explorer" do
    mail = @mailer.game_starts_for_explorer
    
    assert_equal "A new game has started!", mail.subject
    assert_equal ["bruce.s@mavrides.example"], mail.to
    assert_equal ["#{games(:starting_game).id}@mavrides.example"], mail.from
    assert_match <<~TXT.squish, mail.body.encoded.squish
      A new game has started! You, Abelar Lindsay, are the Explorer. You are one of the few, selected to represent humanity 
      on its maiden voyage to the stars. Though you will never know your distant destination, it is a prestigious 
      assignment made all the harder by the knowledge that you will never again see your friends or family or 
      the sun and sky.
      
      The Fleet as just crossed the heliopause, the boundary between the edge of the solar system and interstellar 
      space. Send your starting message to Philip Constantine that lets them know how much you will miss them and how excited you 
      are about the journey that lies ahead of you.
      
      You can answer two or more of the following prompts to help you write your starting message:
      
      1. The ships of the fleet were named after great explorers, artists and teachers. Which do you travel on?
      2. What role have you been assigned to ? Does it match your actual skills or does it feel like a random allocation?
      3. What do you believe awaits your descendants at Tau Ceti?
      4. Who wouldn’t speak to you before your departure? How does that make you feel?
      5. You were allowed to bring only a handful of physical keepsakes with you. What is your prized possession?
    TXT
  end

  test "game_starts_for_earther" do
    mail = @mailer.game_starts_for_earther
    
    assert_equal "A new game has started!", mail.subject
    assert_equal ["vincent.o@mavrides.example"], mail.to
    assert_equal ["#{games(:starting_game).id}@mavrides.example"], mail.from
    assert_match <<~TXT.squish, mail.body.encoded.squish
      A new game has started! You, Philip Constantine, are the Earther. You are one of the many thousands 
      whose application to the Fleet was unsuccessful. Like most of humanity you will live your life under 
      open skies and the light of Sol.
      
      The Fleet is about to depart the solar system. After receiving the first message from Abelar Lindsay, 
      reply to them with a message of congratulations that wishes them a safe journey while also hinting at 
      how you feel about not being chosen to join the Fleet.
      
      You can answer two or more of the following prompts to aid you in writing your starting message:
      
      1. Why was your application for the Fleet rejected? Did you try to appeal the decision?
      2. The day of departure was a global holiday. Who did you celebrate with?
      3. How did you feel in the days after departure as the world returned to normal?
      4. What do you believe awaits humanity at Tau Ceti?
      5. Do you resent those that were chosen?
    TXT
  end
end
