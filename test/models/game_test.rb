require "test_helper"

class GameTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  
  test "#starts! raises if the game is already started" do
    assert_raises { games(:abelar_and_philip).starts! }
  end
  
  test "#starts creates the first round" do
    game = Game.new earther: players(:philip), explorer: players(:abelar)
    
    assert_difference ->{ game.rounds.count } do
      game.starts!
    end
  end
  
  test "#starts! sends a message to the Explorer" do
    game = Game.new earther: players(:philip), explorer: players(:abelar)
    
    assert_enqueued_email_with GameMailer, :game_starts_for_explorer, params: { game: game } do
      game.starts!
    end
  end
  
  test "#starts! sends a message to the Earther" do
    game = Game.new earther: players(:philip), explorer: players(:abelar)
    
    assert_enqueued_email_with GameMailer, :game_starts_for_earther, params: { game: game } do
      game.starts!
    end
  end
  
  test "a new round starts! when the Earther sends their message" do
    game = Game.new explorer: players(:abelar), earther: players(:philip)
    game.starts!
    
    assert_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.earther, subject: "👋", content: "❤️")
    end
  end
  
  test "the current round continues (no new round starts) when the Explorer sends their message" do
    game = Game.create explorer: players(:abelar), earther: players(:philip)
    game.starts!
    
    assert_no_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.explorer, subject: "🖖", content: "💙")
    end
  end
  
  test "a transmission is sent to forward a message upon reception" do
    game    = games(:abelar_and_philip)
    message = Message.new(sender: game.earther, subject: "👋", content: "❤️")
    
    
    expected_prompt = :spades_1 # for this game, the Earther's single event is from the :spades table
    assert_enqueued_email_with MessagesMailer, :transmission, params: { message: message }, args: [{ event_prompt: expected_prompt }] do
      game.messages << message
    end
  end
end
