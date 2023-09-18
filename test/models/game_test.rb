require "test_helper"

class GameTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  
  test "#starts! raises if the game is already started" do
    assert_raises { games(:abelar_and_philip).starts! }
  end
  
  test "#starts creates the first round" do
    game = Game.new earther: characters(:philip), explorer: characters(:abelar)
    
    assert_difference ->{ game.rounds.count } do
      game.starts!
    end
  end
  
  test "#starts! sends a message to the Explorer" do
    game = Game.new earther: characters(:philip), explorer: characters(:abelar)
    
    assert_enqueued_email_with GameMailer, :game_starts_for_explorer, params: { game: game } do
      game.starts!
    end
  end
  
  test "#starts! sends a message to the Earther" do
    game = Game.new earther: characters(:philip), explorer: characters(:abelar)
    
    assert_enqueued_email_with GameMailer, :game_starts_for_earther, params: { game: game } do
      game.starts!
    end
  end
  
  test "a new round starts! when the Earther sends their message" do
    game = Game.new explorer: characters(:abelar), earther: characters(:philip)
    game.starts!
    
    assert_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.earther, subject: "👋", content: "❤️")
    end
  end
  
  test "the current round continues (no new round starts) when the Explorer sends their message" do
    game = Game.create explorer: characters(:abelar), earther: characters(:philip)
    game.starts!
    
    assert_no_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.explorer, subject: "🖖", content: "💙")
    end
  end
  
  test "a transmission is sent to forward a message upon reception" do
    game    = games(:abelar_and_philip)
    message = Message.new(sender: game.earther, subject: "👋", content: "❤️")
    
    assert_enqueued_email_with MessagesMailer, :transmission, params: { message: message } do
      game.messages << message
    end
  end
  
  test "a game ends when it receives a message ending with [Connection Lost]" do
    game = games(:abelar_and_philip)
    
    message = Message.new(sender: game.earther, subject: "farewell", content: <<~TXT)
      This is it.
      [Connection Lost]
    TXT
    
    assert_changes "game.ended?" do
      game.messages << message
    end
  end
  
  # TODO
  test "a game doesn't end if the [Connection Lost] mention is not at the end of the message" do
    skip "TODO"
  end
  
  test "the game ends when the Earther sends their message, if the all the events from a Major Events table have passed" do
    game = games(:ending_game)
    
    assert_changes "game.ended?" do
      game.messages << Message.new(sender: game.earther, subject: "!!!", content: "The player should have added the ending mention")
    end
  end
end
