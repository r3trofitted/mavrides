class Transmission
  delegate_missing_to :@message # TODO: restrict to what is really needed?
  
  def initialize(message)
    @message = message
    @distortion = BasicDistortion.new
  end
  
  def second_to_last?
    major_event_progress > 4
  end
    
  def game_event_prompt
    :"#{recipient_role}.#{major_event_table}_#{major_event_progress}" # e.g. :explorer.spades_3
  end
  
  def personal_event_prompt
    round.event_for(recipient).value # e.g. :ace
  end
  
  def content
    @distortion.apply @message.content, game.events_for(sender).map(&:value)
  end
  
  private
  
  def major_event_table
    round.event_for(recipient).suit
  end
  
  def major_event_progress
    game.events_for(recipient, suit: major_event_table).count
  end
  
  class BasicDistortion
    SUBSTITUTIONS = {
      "2":   [nil, ["Ee", "Rr"]],
      "3":   [nil, ["Cc", "Oo"]],
      "4":   [["Ll", "Ii"], nil],
      "5":   [["Yy", "Qq"], nil],
      "6":   [["Rr", "Ww"], nil],
      "7":   [["Bb", "Kk"], nil],
      "8":   [["Ss", "Bb"], nil],
      "9":   [["Nn", "Pp"], nil],
      "10":  [nil, ["Ii", "Hh"]],
      jack:  [nil, ["Oo", "Ff"]],
      queen: [nil, ["Aa", "Mm"]],
      king:  [nil, ["Tt", "Dd"]],
      ace:   [nil, ["Mm", "Ee"]],
    }
    
    def apply(text, event_values)
      text = text.dup
      
      event_values.tally.each do |card, occurences|
        index = occurences > 1 ? 1 : 0
        
        if substitution = SUBSTITUTIONS.dig(card, index)
          text.tr! *substitution
        end
      end
      
      text
    end
  end
end
