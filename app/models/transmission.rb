class Transmission
  delegate_missing_to :@message
  
  def initialize(message:, round:)
    @message, @round = message, round
  end
    
  def event_prompt
    table    = @round.event_for(recipient).suit
    progress = game.events(player: recipient, suit: table).count
    
    :"#{table}_#{progress}"
  end
end
