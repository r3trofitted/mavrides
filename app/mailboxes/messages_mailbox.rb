class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i
  
  attr_reader :game
  
  before_processing :set_game
  before_processing :bounced!, if: -> { game.blank? || wrong_sender? }
  
  def process
  end
  
  def set_game
    @game ||= Game.find_by(id: mail.to.grep(MATCHER) { $1 })
  end
  
  def wrong_sender?
    game.players.none? { |p| mail.from.include? p.email }
  end
end
