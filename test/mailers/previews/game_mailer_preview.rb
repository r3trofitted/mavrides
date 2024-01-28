class GameMailerPreview < ActionMailer::Preview
  def game_starts_for_explorer
    game = Game.find ActiveRecord::FixtureSet.identify(:running_game)
    GameMailer.with(game:).game_starts_for_explorer
  end

  def game_starts_for_earther
    game = Game.find ActiveRecord::FixtureSet.identify(:running_game)
    GameMailer.with(game:).game_starts_for_earther
  end
end
