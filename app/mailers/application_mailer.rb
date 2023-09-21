class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
  
  def game_email_address(game)
    "%s@%s" % [game.id, Rails.application.config.mailer_domain]
  end
end
