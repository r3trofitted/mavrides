class MessagesMailbox < ApplicationMailbox
  before_processing :bounced!, if: -> { game.blank? }
  
  def process
  end

  def game
    @game ||= Game.running.find_by(id: mail.to.grep(/^([\-\w]+)@mavrides.example/) { $1 }) # FIXME: don't hardcode the domain
  end
end
