class GameMailer < ApplicationMailer
  before_action :set_game

  default from: -> { game_email_address @game }

  def game_starts_for_explorer
    mail to: @game.explorer.player_email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.game_starts_for_earther.subject
  #
  def game_starts_for_earther
    mail to: @game.earther.player_email
  end

  private

  def set_game
    @game = params[:game]
  end
end
