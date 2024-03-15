require "test_helper"

# TODO: split into several files?
class GameTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  # SMELL: this setup is only relevant for some of the tests
  setup do
    @philip = characters(:philip_in_starting_game)
    @abelar = characters(:abelar_in_starting_game)
  end

  test ".prepare creates a new game if none is pending for the players" do
    assert_difference -> { Game.pending.count } do
      Game.prepare earther_player: players(:vincent), explorer_player: players(:bruce), earther_name: "Philip"
    end

    game = Game.pending.last
    assert_equal "Philip", game.earther.name
    assert_nil game.explorer.name
    assert_equal players(:vincent), game.earther_player
    assert_equal players(:bruce), game.explorer_player
  end

  test ".prepare updates the characters if one is already pending for the players" do
    game = Game.pending.create! earther_player: players(:vincent), explorer_player: players(:bruce)
    assert_nil game.explorer.name

    assert_no_difference -> { Game.pending.count } do
      Game.prepare earther_player: players(:vincent), explorer_player: players(:bruce), explorer_name: "Abelar"
    end

    game = Game.pending.last
    assert_equal "Abelar", game.explorer.name # has been updated
    assert_equal players(:vincent), game.earther_player
    assert_equal players(:bruce), game.explorer_player
  end

  test "#starts! raises if the game is already started" do
    assert_raises { games(:starting_game).starts! }
  end

  test "#starts creates the first round" do
    game = Game.new earther: @philip, explorer: @abelar

    assert_difference -> { game.rounds.count } do
      game.starts!
    end
  end

  test "#starts! sends a message to the Explorer" do
    game = Game.new earther: @philip, explorer: @abelar

    assert_enqueued_email_with GameMailer, :game_starts_for_explorer, params: { game: game } do
      game.starts!
    end
  end

  test "#starts! sends a message to the Earther" do
    game = Game.new earther: @philip, explorer: @abelar

    assert_enqueued_email_with GameMailer, :game_starts_for_earther, params: { game: game } do
      game.starts!
    end
  end

  test "a new round starts! when the Earther sends their message" do
    game = Game.new explorer: @abelar, earther: @philip
    game.starts!

    assert_difference -> { game.rounds.count } do
      game.messages << Message.new(sender: game.earther, subject: "👋", content: "❤️")
    end
  end

  test "the current round continues (no new round starts) when the Explorer sends their message" do
    game = Game.create explorer: @abelar, earther: @philip
    game.starts!

    assert_no_difference -> { game.rounds.count } do
      game.messages << Message.new(sender: game.explorer, subject: "🖖", content: "💙")
    end
  end

  test "a transmission is sent to forward a message upon reception" do
    game    = games(:starting_game)
    message = Message.new(sender: game.earther, subject: "👋", content: "❤️")

    assert_enqueued_email_with MessagesMailer, :transmission, params: { message: message } do
      game.messages << message
    end
  end

  test "a game ends when it receives a message ending with [Connection Lost]" do
    game = games(:starting_game)

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
