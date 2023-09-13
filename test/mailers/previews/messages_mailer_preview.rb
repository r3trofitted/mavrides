class MessagesMailerPreview < ActionMailer::Preview

  def transmission
    MessagesMailer.with(message: Message.first).transmission
  end
end

