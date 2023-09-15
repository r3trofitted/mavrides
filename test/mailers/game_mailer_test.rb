require "test_helper"

class GameMailerTest < ActionMailer::TestCase
  test "game_starts_for_explorer" do
    mail = GameMailer.game_starts_for_explorer
    assert_equal "Game starts for explorer", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "game_starts_for_earther" do
    mail = GameMailer.game_starts_for_earther
    assert_equal "Game starts for earther", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
