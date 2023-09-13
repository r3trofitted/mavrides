class MessagesMailbox < ApplicationMailbox
  before_processing :bounced!, if: -> { game.blank? }
  
  def process
  end
  
  def game
    @game ||= Game.find_by(id: mail.to.grep(/^([\-\w]+)@mavrides.example/) { $1 })
  end
end
