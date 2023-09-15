require "test_helper"

class GameMailerTest < ActionMailer::TestCase
  setup do
    @mailer = GameMailer.with game: games(:abelar_and_philip)
  end
  
  # TODO
  test "game_starts_for_explorer" do
    skip "TODO"
    mail = @mailer.game_starts_for_explorer
    
    assert_equal "Game starts for explorer", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  # TODO
  test "game_starts_for_earther" do
    skip "TODO"
    mail = @mailer.game_starts_for_earther
    
    assert_equal "Game starts for earther", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
