class MessagesMailbox < ApplicationMailbox
  MATCHER = /^([\-\w]+)@mavrides.example/i
  
  attr_reader :game, :sender
  
  before_processing :set_game_and_sender
  before_processing :bounced!, if: -> { game.blank? || sender.blank? }
  
  def process
    content = mail.body.to_s
    
    message = Message.new(sender:, content:, subject: mail.subject)
    
    begin
      game.messages << message
    rescue UncaughtThrowError
      bounce_now_with MessagesMailer.with(message:).bounced
    end
  end
  
  private
  
  def set_game_and_sender
    @game   = Game.includes(:earther, :explorer).find_by(id: mail.to.grep(MATCHER) { $1 })
    @sender = game.players.find { |p| mail.from.include? p.email } unless game.blank?
  end
end
