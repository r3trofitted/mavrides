class ApplicationMailbox < ActionMailbox::Base
  routing MessagesMailbox::MATCHER => :messages
end
