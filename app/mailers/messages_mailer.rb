class MessagesMailer < ApplicationMailer
  before_action :set_message

  def transmission(round)
    @transmission = Transmission.new(message: @message, round: round)
    
    mail(
      subject: @transmission.subject,
      from: @transmission.sender_email,
      to: @transmission.recipient_email
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
