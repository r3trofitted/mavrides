class MessagesMailerPreview < ActionMailer::Preview
  def first_transmission
    message = Message.find ActiveRecord::FixtureSet.identify(:first_message_in_running_game)
    MessagesMailer.with(message:).transmission
  end

  def transmission_with_events
    message = Message.find ActiveRecord::FixtureSet.identify(:third_message_in_running_game)
    MessagesMailer.with(message:).transmission
  end
end
