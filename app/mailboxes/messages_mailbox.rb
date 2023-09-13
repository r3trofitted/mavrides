class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i
  
  before_processing :bounced!, if: -> { game.blank? or wrong_sender? }
  
  def process
  end
  
  def game
    @game ||= Game.find_by(id: mail.to.grep(MATCHER) { $1 })
  end
  
  def wrong_sender?
    game.players.none? { |p| mail.from.include? p.email }
  end
end
