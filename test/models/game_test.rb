require "test_helper"

class GameTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  
  test "#starts creates the first round" do
    game = Game.new earther: players(:philip), explorer: players(:abelar)
    
    assert_difference ->{ game.rounds.count } do
      game.starts
    end
  end
  
  test "#starts sends a message to the Explorer" do
    game = Game.new earther: players(:philip), explorer: players(:abelar)
    
    assert_enqueued_email_with GameMailer, :game_starts_for_explorer, params: { game: game } do
      game.starts
    end
  end
  
  test "#starts sends a message to the Earther" do
    game = Game.new earther: players(:philip), explorer: players(:abelar)
    
    assert_enqueued_email_with GameMailer, :game_starts_for_earther, params: { game: game } do
      game.starts
    end
  end
  
  test "a new round starts when the explorer sends their message" do
    game = Game.create explorer: players(:abelar), earther: players(:philip)
    game.starts
    
    assert_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.explorer)
    end
  end
  
  test "the current round ends when the earther sends their message" do
    game = Game.create explorer: players(:abelar), earther: players(:philip)
    game.starts
    
    assert_no_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.earther)
    end
  end
end
