class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i

  before_processing :bounced!, if: -> { game.blank? or wrong_sender? }

  def process
  end

  def game
    @game ||= Game.running.find_by(id: mail.to.grep(MATCHER) { $1 })
  end

  def wrong_sender?
    Player.where(email: mail.from).participating_in(game).none?
  end
end
