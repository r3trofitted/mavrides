class MessagesMailer < ApplicationMailer
  before_action :set_message

  def transmission(event_prompt:)
    mail(
      subject: @message.subject,
      from: @message.sender_email,
      to: @message.recipient_email
    )
  end
  
  # TODO
  def bounced
  end
  
  private
  
  def set_message
    @message = params[:message]
  end
end
