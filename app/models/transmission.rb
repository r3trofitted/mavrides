class Transmission
  delegate_missing_to :@message # TODO: restrict to what is really needed?

  def initialize(message)
    @message    = message
    @event      = round.event_for(recipient)
    @distortion = BasicDistortion.new
  end

  def has_events?
    @event.present?
  end

  def very_first?
    sent_by?(game.explorer) && round_number == 1
  end

  def second_to_last?
    major_event_progress > 4
  end

  def game_event_prompt
    :"#{recipient_role}.#{major_event_table}_#{major_event_progress}" if has_events? # e.g. :explorer.spades_3
  end

  def personal_event_prompt
    @event.value if has_events? # e.g. :ace
  end

  def content
    @distortion.apply @message.content, distortion_factors
  end

  def lag
    2.weeks # SLIME
  end

  def elapsed_time
    lag + 1.week # SLIME
  end

  def distortion_factors
    game.rounds.where(number: [1..round_number]).filter_map { |r| r.event_for(sender)&.value }
  end

  private

  def major_event_table
    @event.suit
  end

  def major_event_progress
    if has_events?
      game.events_for(recipient, suit: @event.suit).count
    else
      0
    end
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
      ace:   [nil, ["Mm", "Ee"]]
    }

    def apply(text, factors)
      text = text.dup

      factors.tally.each do |factor, occurences|
        index = occurences > 1 ? 1 : 0

        if substitution = SUBSTITUTIONS.dig(factor, index)
          text.tr! *substitution
        end
      end

      text
    end
  end
end
