class ApplicationMailbox < ActionMailbox::Base
  routing /^new_game@/i => :games

  # Be careful to keep this last, since it's a bit of a catch-all
  routing MessagesMailbox::MATCHER => :messages
end
