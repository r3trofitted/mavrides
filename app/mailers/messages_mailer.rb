class MessagesMailer < ApplicationMailer
  before_action :set_message

  def transmission
    @transmission = Transmission.new(@message)
    
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
