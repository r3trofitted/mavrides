require "test_helper"

class GameTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "#starts creates the first round" do
    game = Game.new earther: characters(:philip), explorer: characters(:abelar)

    assert_difference ->{ game.rounds.count } do
      game.starts
    end
  end

  test "#starts sends a message to the Explorer" do
    game = Game.new earther: characters(:philip), explorer: characters(:abelar)

    assert_enqueued_email_with GameMailer, :game_starts_for_explorer, params: { game: game } do
      game.starts
    end
  end

  test "#starts sends a message to the Earther" do
    game = Game.new earther: characters(:philip), explorer: characters(:abelar)

    assert_enqueued_email_with GameMailer, :game_starts_for_earther, params: { game: game } do
      game.starts
    end
  end

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
