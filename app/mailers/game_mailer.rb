class GameMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.game_starts_for_explorer.subject
  #
  def game_starts_for_explorer
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.game_starts_for_earther.subject
  #
  def game_starts_for_earther
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
