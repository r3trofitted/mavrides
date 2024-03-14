class GamesMailbox < ApplicationMailbox
  before_processing :extract_players, :extract_character

  attr_reader :character_role
  attr_accessor :character_name

  def process
    # TODO: checks & validations
    Game.prepare earther_player:, explorer_player:, earther_name:, explorer_name:
  end

  private

  def extract_players
    # The player's name can be updated while we're at it
    @requesting_player = Player
                          .find_or_create_by(email: mail.sender)
                          .tap { |p| p.update name: mail[:from].display_names.first }

    @other_player = Player
                      .create_with(name: mail[:cc].display_names.first)
                      .find_or_create_by(email: mail[:cc].addresses.first)
  end

  def extract_character
    self.character_name, self.character_role = mail.subject.match(/([\w\s]+),\s*(explorer|earther)/i).captures
  end

  def character_role=(val)
    @character_role = val.downcase.inquiry
  end

  def earther_name
    character_name if character_role.earther?
  end

  def earther_player
    character_role.earther? ? @requesting_player : @other_player
  end

  def explorer_name
    character_name if character_role.explorer?
  end

  def explorer_player
    character_role.explorer? ? @requesting_player : @other_player
  end
end
