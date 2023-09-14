require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "a new round starts when the explorer sends their message" do
    game = Game.create explorer: players(:abelar), earther: players(:philip)
    assert_empty game.rounds
    
    assert_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.explorer)
    end
  end
  
  test "the current round ends when the earther sends their message" do
    game = Game.create explorer: players(:abelar), earther: players(:philip)
    game.messages.create! sender: game.explorer
    refute_empty game.rounds
    
    assert_no_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.earther)
    end
  end
end
