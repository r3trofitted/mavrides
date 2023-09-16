class Transmission
  delegate_missing_to :@message
  
  def initialize(message:)
    @message = message
  end
    
  def event_prompt
    table    = game.rounds.current.event_for(recipient).suit
    progress = game.events(player: recipient, suit: table).count
    
    :"#{table}_#{progress}"
  end
end
