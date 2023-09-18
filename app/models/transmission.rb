class Transmission
  delegate_missing_to :@message # TODO: restrict to what is really needed?
  
  def initialize(message)
    @message = message
  end
  
  def second_to_last?
    major_event_progress > 4
  end
    
  def game_event_prompt
    :"#{recipient.role}.#{major_event_table}_#{major_event_progress}" # e.g. :explorer.spades_3
  end
  
  def personal_event_prompt
    round.event_for(recipient).value # e.g. :ace
  end
  
  private
  
  def major_event_table
    round.event_for(recipient).suit
  end
  
  def major_event_progress
    game.events(character: recipient, suit: major_event_table).count
  end
end
