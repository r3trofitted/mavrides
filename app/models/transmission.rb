class Transmission
  delegate_missing_to :@message
  
  def initialize(message:)
    @message = message
  end
    
  def event_prompt
    role     = recipient.eql?(game.earther) ? :earther : :explorer # SMELL
    
    table    = game.rounds.current.public_send("#{role}_event").suit # SMELL
    progress = game.events(player: recipient, suit: table).count
    
    :"#{table}_#{progress}"
  end
end
