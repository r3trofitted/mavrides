class Transmission
  delegate_missing_to :@message
  
  def initialize(message)
    @message = message
  end
    
  def event_prompt
    table    = round.event_for(recipient).suit
    progress = game.events(character: recipient, suit: table).count
    
    :"#{recipient.role}.#{table}_#{progress}" # e.g. :explorer.spades_3
  end
end
