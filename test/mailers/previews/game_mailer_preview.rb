# Preview all emails at http://localhost:3000/rails/mailers/game_mailer
class GameMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/game_mailer/game_starts_for_explorer
  def game_starts_for_explorer
    GameMailer.game_starts_for_explorer
  end

  # Preview this email at http://localhost:3000/rails/mailers/game_mailer/game_starts_for_earther
  def game_starts_for_earther
    GameMailer.game_starts_for_earther
  end
end
