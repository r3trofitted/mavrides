class ApplicationMailbox < ActionMailbox::Base
  routing /@mavrides.example/i => :messages
end
