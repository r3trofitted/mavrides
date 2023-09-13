class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i
  
  attr_reader :game
  
  before_processing :set_game
  before_processing :bounced!, if: -> { game.blank? || wrong_sender? }
  
  def process
    sender    = game.players.find { |p| mail.from.include? p.email }
    content   = mail.body.to_s
    
    if message = game.messages.create(sender:, content:, subject: mail.subject)
      MessagesMailer.with(message:).transmission.deliver_later
    end
  end
  
  def set_game
    @game ||= Game.find_by(id: mail.to.grep(MATCHER) { $1 })
  end
  
  def wrong_sender?
    game.players.none? { |p| mail.from.include? p.email }
  end
end
