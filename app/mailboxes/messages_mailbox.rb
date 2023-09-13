class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i
  
  before_processing :bounced!, if: -> { game.blank? }
  
  def process
  end
  
  def game
    @game ||= Game.find_by(id: mail.to.grep(MATCHER) { $1 })
  end
end
