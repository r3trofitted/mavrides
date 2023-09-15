require "test_helper"

class GameTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "#starts! raises if the game is already started" do
    assert_raises { games(:running_game).starts! }
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

  test "a new round starts when the earther player sends their message" do
    game = Game.new explorer: characters(:abelar), earther: characters(:philip)
    game.starts!

    assert_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: players(:vincent))
    end
  end

  test "the current round continues (no new round starts) when the explorer player sends their message" do
    game = Game.create explorer: characters(:abelar), earther: characters(:philip)
    game.starts!

    assert_no_difference ->{ game.rounds.count } do
      game.messages << Message.new(sender: players(:bruce))
    end
  end
end
