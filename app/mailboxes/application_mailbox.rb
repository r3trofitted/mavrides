class ApplicationMailbox < ActionMailbox::Base
  routing %r|@mavrides.example\Z|i => :messages # FIXME: don't hardcode the domain
end
