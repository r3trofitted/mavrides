require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "a new round starts when the explorer player sends their message" do
    game = Game.create explorer: characters(:abelar), earther: characters(:philip)
    assert_empty game.rounds

    assert_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: game.explorer_player)
    end
  end

  test "the current round ends when the earther player sends their message" do
    game = Game.create explorer: characters(:abelar), earther: characters(:philip)
    game.messages << Message.new(sender: players(:bruce))
    assert_not_empty game.rounds

    assert_no_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: players(:vincent))
    end
  end
end
