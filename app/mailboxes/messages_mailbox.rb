class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i

  attr_reader :game, :sender

  before_processing :set_game_and_sender
  before_processing :bounced!, if: -> { game.blank? || sender.blank? }

  def process
    content = mail.body.to_s

    if message = game.messages.create(sender:, content:, subject: mail.subject)
      MessagesMailer.with(message:).transmission.deliver_later
    end
  end

  private

  def set_game_and_sender
    @game   = Game.running.find_by(id: mail.to.grep(MATCHER) { $1 })
    unless @game.blank?
      @sender = begin
                  Player.where(email: mail.from).participating_in(@game).sole
                rescue ActiveRecord::RecordNotFound
                  nil
                end
    end
  end
end
