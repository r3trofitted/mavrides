class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i

  attr_reader :game, :sender

  before_processing :set_game_and_sender
  before_processing :bounced!, if: -> { game.blank? || sender.blank? }

  def process
    message = Message.new sender:, content: mail.body.to_s, subject: mail.subject

    begin
      game.messages << message
    rescue UncaughtThrowError
      bounce_now_with MessagesMailer.with(message:).bounced
    end
  end

  private

  def set_game_and_sender
    @game   = Game.running.find_by(id: mail.to.grep(MATCHER) { $1 })
    unless @game.blank?
      # We don't really care if there is not sender (the mail will bounce), but do want to raise
      # if there is more than one possible sender.
      @sender = begin
                  Player.where(email: mail.from).participating_in(@game).sole
                rescue ActiveRecord::RecordNotFound
                  nil
                end
    end
  end
end
